#define _CRT_SECURE_NO_WARNINGS

#include <stdio.h>
#include <string.h>



extern AMOUNT;
extern GA1;
typedef struct goods {
	char GOODSNAME[10];
	short BUYPRICE;
	short SELLPRICE;
	short BUYNUM;
	short SELLNUM;
	short RATE;
}GOODS;

void FUNC1(void);
void FUNC2(void);
void FUNC3(void);
void FUNC4(void);
void FUNC5(void);
void FUNC6(void);

char trueName[10] = "liuYIkang\0";
char truePassword[15] = "U201914873\0";
int main()
{
	char inName[10];
	char inPassword[15];
	printf("User Name:\n");
	scanf("%s", inName);
	if (strcmp(inName, trueName) != 0)
	{
		printf("Invalid User Name\n");
		printf("Input User Name again!\n");
		scanf("%s", inName);
	}
	printf("Password:\n");
	scanf("%s", inPassword);
	if (strcmp(inPassword, truePassword) != 0)
	{
		printf("Invalid Password\n");
		printf("Input Password again!\n");
		scanf("%s", inPassword);
	}
	printf("Success Login in!\n");
	int option = 0;
	while (option != 9)
	{
		printf("Welcome to my shop!\n");
		printf("Please choice function 1-9\n");
		printf("---------------------------------------------\n");
		printf("1.Search for products and print information\n");
		printf("2.Shipment\n");
		printf("3.Purchase\n");
		printf("4.Calculate profit margin\n");
		printf("5.Profit margin ranking\n");
		printf("6.Add Good\n");
		printf("9.EXIT\n");
		printf("---------------------------------------------\n");
		printf("Please Enter a Number(1~9):");
		scanf("%d", &option);
		printf("\n");
		switch (option)
		{
		case 1:

			FUNC1();
			break;
		case 2:
			FUNC2();
			break;
		case 3:
			FUNC3();
			break;
		case 4:
			FUNC4();
			break;
		case 5:
			FUNC5();
			break;
		case 6:
			FUNC6();
			break;

		default:
			break;
		}
		printf("-------------------end function----------------\n");
		system("pause");
		system(("cls"));
	}
	return 0;
}


void FUNC6(void)
{
	AMOUNT++;
	GOODS(* ptr)[10] = &GA1;
	printf("Please input new GOOD's name\n");
	scanf("%s", &((*ptr)[AMOUNT-1].GOODSNAME));
	printf("Please input new GOOD's buyprice\n");
	scanf("%hd", &((*ptr)[AMOUNT - 1].BUYPRICE));
	printf("Please input new GOOD's sellprice\n");
	scanf("%hd", &((*ptr)[AMOUNT - 1].SELLPRICE));
	printf("Please input new GOOD's buynum\n");
	scanf("%hd", &((*ptr)[AMOUNT - 1].BUYNUM));
	short a;
	printf("Please input new GOOD's sellnum\n");
	scanf("%hd", &a);
	while (a > ((*ptr)[AMOUNT - 1].BUYNUM))
	{
		printf("Sell number can't be greater than buy number!\n");
		printf("Please input new GOOD's sellnum\n");
		scanf("%hd", &a);
	}
	((*ptr)[AMOUNT - 1].SELLNUM) = a;
	((*ptr)[AMOUNT - 1].RATE) = 0;
	printf("New good %s had beem added\n", (*ptr)[AMOUNT - 1].GOODSNAME);

}