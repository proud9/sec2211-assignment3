#define _POSIX_C_SOURCE 200809L

#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>
#include <sys/types.h>
#include <sys/wait.h>

int initialized_global = 42;  // Stored in initialized data
int uninitialized_global;     // Stored in BSS

static void show_memory(void)
{
    int local_number = 7;                 // Local variable (typically stack)
    int *heap_number = malloc(sizeof *heap_number);

    if (heap_number == NULL) {
        perror("malloc");
        exit(EXIT_FAILURE);
    }

    *heap_number = 99;

    printf("PID: %ld\n", (long)getpid());
    printf("Initialized global at %p = %d\n",
           (void *)&initialized_global, initialized_global);
    printf("Uninitialized global at %p = %d\n",
           (void *)&uninitialized_global, uninitialized_global);
    printf("Local variable at %p = %d\n",
           (void *)&local_number, local_number);
    printf("Heap value at %p = %d\n",
           (void *)heap_number, *heap_number);

    free(heap_number);
}

static void use_file(void)
{
    FILE *file = fopen("assignment-output.txt", "w");

    if (file == NULL) {
        perror("fopen");
        return;
    }

    fprintf(file, "File operation from PID %ld\n", (long)getpid());
    fclose(file);
}

int main(void)
{
    show_memory();
    use_file();

    pid_t child_pid = fork();

    if (child_pid < 0) {
        perror("fork");
        return EXIT_FAILURE;
    }

    if (child_pid == 0) {
        printf("Child PID: %ld; parent PID: %ld\n",
               (long)getpid(), (long)getppid());
        fflush(stdout);

        sleep(20);  // Inspect the child during this pause.

        execlp("ls", "ls", "-l", "assignment-output.txt", (char *)NULL);
        perror("execlp");  // Reached only if exec fails.
        _exit(127);
    }

    printf("Parent PID: %ld; child PID: %ld\n",
           (long)getpid(), (long)child_pid);
    printf("Parent waiting for child...\n");
    fflush(stdout);

    int status;
    if (waitpid(child_pid, &status, 0) < 0) {
        perror("waitpid");
        return EXIT_FAILURE;
    }

    if (WIFEXITED(status)) {
        printf("Child exited with status %d\n", WEXITSTATUS(status));
    } else if (WIFSIGNALED(status)) {
        printf("Child ended from signal %d\n", WTERMSIG(status));
    }

    return EXIT_SUCCESS;
}
