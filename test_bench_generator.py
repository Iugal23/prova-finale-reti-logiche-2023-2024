import random

def gen_scenario_input():
    K=random.randint(0,1023)
    scenario_input=[]
    for i in range(0,K):
        if(random.randint(1,100)<=20):
            scenario_input.append(0)
        else:
            scenario_input.append(random.randint(0,255))
        scenario_input.append(0)
    return K,scenario_input

def gen_scenario_full(scenario_input):
    last_value=0
    credibility=0
    scenario_full=[]
    for i in range(len(scenario_input)):
        if i%2==0:
            if scenario_input[i]!=0:
                credibility=31
                last_value=scenario_input[i]
                scenario_full.append(scenario_input[i])
                
            elif (credibility>0):
                credibility-=1
                scenario_full.append(last_value)
            else:
                scenario_full.append(last_value)
            scenario_full.append(credibility)
    return scenario_full


NUMBER_OF_TB=1000

for i in range(0,NUMBER_OF_TB):
    template=open("Testbenches\\project_tb.vhd","r")
    new_tb=open(f"Testbenches\\project_tb_{i}.vhd","w")
    K,scenario_input=gen_scenario_input()
    scenario_full=gen_scenario_full(scenario_input)


    for line in template :
        if(f"entity project_tb" in line):
            new_line=f"entity project_tb_{i} is\n"
        elif(f"end project_tb"in line):
            new_line=f"end project_tb_{i};\n"
        elif("architecture project_tb_arch" in line):
            new_line=f"architecture project_tb_arch_{i} of project_tb_{i} is\n"
        elif("constant SCENARIO_LENGTH" in line):
            new_line=f"constant SCENARIO_LENGTH : integer := {K};\n"
        elif("signal scenario_input" in line):
            new_line="signal scenario_input : scenario_type := (" + ",".join(map(str,scenario_input))+");\n"
        elif("signal scenario_full" in line): 
            new_line="signal scenario_full  : scenario_type := (" + ",".join(map(str,scenario_full))+");\n"
        else:
            new_line=line  
        new_tb.write(new_line)

    template.close()
    new_tb.close()

