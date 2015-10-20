package cup.example;
import java_cup.runtime.ComplexSymbolFactory;
import java_cup.runtime.ComplexSymbolFactory.Location;
import java_cup.runtime.Symbol;
import java.lang.*;
import java.io.InputStreamReader;

%%

%class Lexer
%implements sym
%public
%unicode
%line
%column
%cup
%char
%{
	

    public Lexer(ComplexSymbolFactory sf, java.io.InputStream is){
		this(is);
        symbolFactory = sf;
    }
	public Lexer(ComplexSymbolFactory sf, java.io.Reader reader){
		this(reader);
        symbolFactory = sf;
    }
    
    private StringBuffer sb;
    private ComplexSymbolFactory symbolFactory;
    private int csline,cscolumn;

    public Symbol symbol(String name, int code){
		return symbolFactory.newSymbol(name, code,
						new Location(yyline+1,yycolumn+1, yychar), // -yylength()
						new Location(yyline+1,yycolumn+yylength(), yychar+yylength())
				);
    }
    public Symbol symbol(String name, int code, String lexem){
	return symbolFactory.newSymbol(name, code, 
						new Location(yyline+1, yycolumn +1, yychar), 
						new Location(yyline+1,yycolumn+yylength(), yychar+yylength()), lexem);
    }
    
    protected void emit_warning(String message){
    	System.out.println("scanner warning: " + message + " at : 2 "+ 
    			(yyline+1) + " " + (yycolumn+1) + " " + yychar);
    }
    
    protected void emit_error(String message){
    	System.out.println("scanner error: " + message + " at : 2" + 
    			(yyline+1) + " " + (yycolumn+1) + " " + yychar);
    }
%}


comentario = "/*" ~"*/"
espaco = [ \n\t\r]
letra = [A-Z]|[a-z]
digito = [0-9]
sinais = ( "-" | "+" | "" )
natural = ({digito} | [1-9]{digito}+)
inteiro = {sinais}{natural}
float = {inteiro}"."{digito}+(("E" | "e"){sinais}?{natural}?)?
id = ({letra} | _ )({letra} | {digito} | _ )*


%eofval{
    return symbolFactory.newSymbol("EOF",sym.EOF);
%eofval}

%state CODESEG

%%  

boolean 	{ return symbolFactory.newSymbol(yytext(), BOOLEAN); }
class		{ return symbolFactory.newSymbol(yytext(), CLASS); }
do			{ return symbolFactory.newSymbol(yytext(), DO); }
else		{ return symbolFactory.newSymbol(yytext(), ELSE); }
extends		{ return symbolFactory.newSymbol(yytext(), EXTENDS); }
false		{ return symbolFactory.newSymbol(yytext(), FALSE); }
for			{ return symbolFactory.newSymbol(yytext(), FOR); }
if			{ return symbolFactory.newSymbol(yytext(), IF); }
int			{ return symbolFactory.newSymbol(yytext(), INT); }
new			{ return symbolFactory.newSymbol(yytext(), NEW); }
public		{ return symbolFactory.newSymbol(yytext(), PUBLIC); }
return		{ return symbolFactory.newSymbol(yytext(), RETURN); }
static		{ return symbolFactory.newSymbol(yytext(), STATIC); }
this		{ return symbolFactory.newSymbol(yytext(), THIS); }
true		{ return symbolFactory.newSymbol(yytext(), TRUE); }
void		{ return symbolFactory.newSymbol(yytext(), VOID); }
while		{ return symbolFactory.newSymbol(yytext(), WHILE); }
main	 	{ return symbolFactory.newSymbol(yytext(), MAIN); }
length	 	{ return symbolFactory.newSymbol(yytext(), LENGTH); }
string	 	{ return symbolFactory.newSymbol(yytext(), STRING); }

"("			{ return symbolFactory.newSymbol(yytext(), L_PARE); }
")"			{ return symbolFactory.newSymbol(yytext(), R_PARE); }
"{"			{ return symbolFactory.newSymbol(yytext(), L_CHA); }
"}"			{ return symbolFactory.newSymbol(yytext(), R_CHA); }
"["			{ return symbolFactory.newSymbol(yytext(), L_CON); }
"]"			{ return symbolFactory.newSymbol(yytext(), R_CON); }

"||"		{ return symbolFactory.newSymbol(yytext(), OR); }
"&&"		{ return symbolFactory.newSymbol(yytext(), AND); }
"=="		{ return symbolFactory.newSymbol(yytext(), EQ); }
"!="		{ return symbolFactory.newSymbol(yytext(), NEQ); }
"<"			{ return symbolFactory.newSymbol(yytext(), LT); }
"<="		{ return symbolFactory.newSymbol(yytext(), LEQ); }
">"			{ return symbolFactory.newSymbol(yytext(), GT); }
">="		{ return symbolFactory.newSymbol(yytext(), GEQ); }
"+"			{ return symbolFactory.newSymbol(yytext(), PLUS); }
"-"			{ return symbolFactory.newSymbol(yytext(), MINUS); }
"*"			{ return symbolFactory.newSymbol(yytext(), TIMES); }
"/"			{ return symbolFactory.newSymbol(yytext(), DIV); }
"%"			{ return symbolFactory.newSymbol(yytext(), MOD); }
"!"			{ return symbolFactory.newSymbol(yytext(), NOT); }

";"			{ return symbolFactory.newSymbol(yytext(), SEMI); }
"."			{ return symbolFactory.newSymbol(yytext(), DOT); }
"="			{ return symbolFactory.newSymbol(yytext(), ATB); }
","			{ return symbolFactory.newSymbol(yytext(), COMMA); }

{espaco}	{/*NADA */}

{comentario} {/*NADINNHA*/}

{inteiro}	{ return symbolFactory.newSymbol(yytext(), INTEGER, Integer.parseInt(yytext())); }

{float}		{ return symbolFactory.newSymbol(yytext(), FLOAT, Float.parseFloat(yytext())); }

{id}		{return symbolFactory.newSymbol(yytext(), ID, yytext());}