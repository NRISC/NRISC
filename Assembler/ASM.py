# NRISC Assembly to bytecode compiler
#
#
#---------------
#Imports
import sys
#globals
Instruction={'NOP':0,'HALT':1,'WAIT':2,'SLEEP':3,'CALL':4,'RET':5,'RETI':6,'LW':7,'SW':8,'LI':9,'JMP':10,'JZ':11,'JC':12,'JM':13,'ADD':14,'SUB':15,'AND':16,'R':17,'XOR':18,'SHR':19,'RTR':20,'SHL':21,'RTL':22,'NOT':23,'TWC':24,'INC':25,'DEC':26}
Opcode=['0','0','0','0','0','0','0','1','2','3','4','5','6','7','8','9','A','B','C','D','D','E','E','F','F','F','F']
OperatorGroup=[1,1,1,1,2,1,1,4,4,5,2,2,2,2,4,4,4,4,4,3,3,3,3,3,3,3,3]
OperatorGroup1={'NOP':'000','HALT':'100','WAIT':'200','SLEEP':'300','RET':'500','RETI':'600'} #instrucoes com apenas um operando, apenas mnemonico
OperatorGroup2={'CALL':'4','JMP':'0','JZ':'0','JC':'0','JM':'0'}#instrucoes com 3 operadores,mnemonico+RF1+RF2
OperatorGroup3={'SHR':'0','RTR':'1','SHL':'0','RTL':'1','NOT':'0','TWC':'1','INC':'2','DEC':'3'}#instrucoes com 3 operadores,mnemonico+RD+RF1
REGs={'R0':'0','R1':'1','R2':'2','R3':'3','R4':'4','R5':'5','R6':'6','R7':'7','R8':'8','R9':'9','R10':'A','R11':'B','R12':'C','R13':'D','R14':'E','R15':'F'}
#main

print "Iniciando ..."
'''
====== Carregamento do arquivo =====
'''
#arquivo=open((sys.argv[0]),'r')
if(len(sys.argv)>1):
    print "Lendo o arquivo "+str((sys.argv[1]))
    arquivo=open(sys.argv[1],'r')
else:
    print "Lendo o arquivo "+str((sys.argv[0]))+" Test dev mode"
    arquivo=open("D:\Eletronica\Projects\NRISC\Assembler\Test.asm",'r')#arquivo de teste
code=arquivo.readlines()
arquivo.close()
print "Carregado "+str(len(code))+" linha"+("s." if len(code)>1 else ".")
'''
====== Inicio da compilacao=====
'''
out=""
comentCount=0
lineCount=0
errorCount=0
tmp=""
op=""
RD=""
RF1=""
RF2=""
LI=0;

for x in code:
    lineCount+=1
    tmp=x.split( )
    if(tmp[0]=="//"):
        comentCount+=1
    else:
        try: #testa opcode
            op=Instruction[tmp[0].upper()]
            if(OperatorGroup[op]==1):
                out+=Opcode[op]+OperatorGroup1[tmp[0].upper()]+"\n"
            elif (OperatorGroup[op]==2):
                try:
                    RF1=REGs[tmp[1].upper()]
                    RF2=REGs[tmp[2].upper()]
                    out+=Opcode[op]+OperatorGroup2[tmp[0].upper()]+RF1+RF2+"\n"
                except:
                    print "registrador invalido, linha "+str(lineCount)
                    errorCount+=1
            elif (OperatorGroup[op]==3):
                try:
                    RD=REGs[tmp[1].upper()]
                    RF1=REGs[tmp[2].upper()]
                    out+=Opcode[op]+RD+RF1+OperatorGroup3[tmp[0].upper()]+"\n"
                except:
                    print "registrador invalido, linha "+str(lineCount)
                    errorCount+=1
            elif(OperatorGroup[op]==4):
                try:
                    RD=REGs[tmp[1].upper()]
                    RF1=REGs[tmp[2].upper()]
                    RF2=REGs[tmp[3].upper()]
                    out+=Opcode[op]+RD+RF1+RF2+"\n"
                except:
                    print "registrador invalido, linha "+str(lineCount)
                    errorCount+=1
            elif(OperatorGroup[op]==5):
                try:
                    RD=REGs[tmp[1].upper()]
                    LI=int(tmp[2],0)
                    if(LI<256 and LI>15):
                        out+=Opcode[op]+RD+("%X" % LI)+"\n"

                    elif(LI<16 and LI>-1):
                        out+=Opcode[op]+RD+'0'+("%X" % LI)+"\n"
                    else:
                        print "valor imediato fora da faixa"
                        errorCount+=1
                except:
                    print "registrador invalido, linha "+str(lineCount)
                    errorCount+=1
        except:
            print "insctrucao invalida, linha "+str(lineCount)
            errorCount+=1

print ("Arquivo Compilado, "+str(len(code)-comentCount)+" palavras de code"  if errorCount==0 else str(errorCount)+" erro"+(" " if errorCount==1 else "s ")+"encontrado"+("." if errorCount==1 else "s."))
if(len(sys.argv)>1):
    print "Gravando "+str(sys.argv[1].split('.')[0])+".hex"
    file = open(str(sys.argv[1].split('.')[0])+".hex","w")
else:
    print "Gravando o arquivo - Test dev mode"
    file = open("D:\Eletronica\Projects\NRISC\Assembler\Test.hex","w")


file.write(out)
file.close()

#print out
