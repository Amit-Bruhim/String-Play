#include <stdio.h>
#include "pstring.h"

#define arraySize(x) (sizeof(x) / sizeof(x[0]))

extern void run_func(int choice, Pstring *pstr1, Pstring *pstr2);

void get_pstring(Pstring *pstr) {
	/* Get pstring length */
	printf("\033[0;32mEnter Pstring length:\033[0m ");
	scanf("%hhu", &pstr->len);

	/* Flush stdin buffer */
	int c;
	while ((c = getchar()) != '\n' && c != EOF);
	
	/* Get pstring */
	printf("\033[0;32mEnter Pstring:\033[0m ");
	fgets(pstr->str, pstr->len + 1, stdin);

	/* Remove trailing newline */
	pstr->str[pstr->len] = '\0';
}

int main(void) {
	/* Prompt user for two Pstrings */
	Pstring pstr1, pstr2;
	get_pstring(&pstr1);
	get_pstring(&pstr2);

	/* Print menu for user */
	char *descriptions[] = {
		"31. pstrlen",
		"33. swapCase",
		"34. pstrijcpy",
	};

	puts("\033[0;32mChoose a function:\033[0m");

	for (int i = 0; i < arraySize(descriptions); i++) {
		printf("\t%s\n", descriptions[i]);
	}

	/* Get user choice, and call func_select */
	int choice;
	scanf("%d", &choice);
	run_func(choice, &pstr1, &pstr2);
	
	return 0;
}
