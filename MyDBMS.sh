#!/bin/bash
export LC_COLLATE=C
shopt -s extglob
export reset="\033[m"
clear
mainMenu(){
    
    if [ ! -d ~/DataBase ]
    then
        mkdir ~/DataBase
    fi
     echo -e "\e[1;34m              --------------------------WELCOME $USER-------------------------- $reset"
    select choice in " Create Database" " List Databases" " Connect to a Database" " Drop Database" " Exit"
    do
        case $REPLY in
            #CREATING DB-------------------
            
            1) read -p "Enter Database name: " name
                if [[ -z "$name" || ! $name =~ ^[a-zA-Z] ]]
                then
                    echo -e "\e[1;31m Please enter a correct DB name.$reset"
                else
                    if [ ! -d ~/DataBase/$name ]
                    then
                        mkdir ~/DataBase/$name
                        echo  "$name database created successfully "
                    else
                        echo  "$name database already exists "
                    fi
                fi
            ;;
            2) ls ~/DataBase
            ;;
            #CONNECTING TO DB --------------------------------
            
            
            3) read  -p "Enter Database name: " DBname
                if [ -z "$DBname" ]
                then
                    echo -e " \e[1;31mPlease enter a correct DB name.$reset"
                else
                    if [ -d ~/DataBase/$DBname ]
                    then
                        clear
                        cd /$HOME/DataBase/$DBname
                        echo -e "\e[1;34m connected to $DBname successfully $reset"
                        
                        tablesMenu
                        
                    else
                        echo -e "\e[1;31mDatabase doesn't exist.$reset"
                    fi
                fi
            ;;
            
            #DELETE DB-----------------------------
            
            4) alter(){ read -p "Enter Database name: " name
                    
                    if [[ -z $name || ! -d $HOME/DataBase/$name ]]
                    then
                       echo -e"\e[1;31mEnter a correct DB name.$reset"
                    else
                        cd ~/DataBase
                        rm -r  $name
                        echo -e " \e[1;34m $name database removed successfully.$reset"
                        
                    fi
                    
                }
                alter
            ;;
            5) exit
            ;;
            *) echo -e "\e[1;31m Invalid Option.$reset"
            ;;
            
        esac
    done
}

clear

tablesMenu(){
    
   echo -e "\n \e[1;34m   -----------------------------------Tables Menu--------------------------------------$reset"
    
    select choice in " List all Tables" " Create a new Table" " Insert into Table" "Selecting" "Delete from Table" "Delete Table" " Back to main menu"  "Exit" "Update from Table"  # "Update Table" "Delete from table" "Drop Table" "Back to main menu" " Exit"
    do
        case $REPLY in
            
            #LISTING ------------------------
            1) ls
                
            ;;
            
            #CREATING -------------------------
            
            2) typeset -i Num_col
                typeset -i iter
                
                read  -p "Enter Table name: " name
                
                if [[ -z "$name" || ! $name =~ ^[a-zA-Z] ]]
                then
                    echo -e "\e[1;31mPlease enter correct Table name $reset"
                else
                    if [ ! -f $name ]
                    then
                        typeset -i index=0
                        declare -a record
                        read  -p " Number of Columns: " Num_col
                        iter=0
                        while [ $iter -lt $Num_col ]
                        do
                            let iter=$iter+1
                            echo "Enter Col_Name and Datatype(int/string) of col $iter: "
                            read col_name col_type
                            
                            while [[ $col_name == [0-9]* ]]
                            do
                               echo -e "\e[1;31m invalid column name $reset"
                                read  -p " Enter valid column name: " col_name
                            done
                            while [[ $col_type != int && $col_type != string ]]
                            do
                               echo -e "\e[1;31m invalid column DataType \n $reset"
                                read -p ">> Enter valid column DataType: " col_type
                            done
                            
                            record[index]=$col_name":"$col_type"|"
                            index=$index+1
                            
                        done
                        
                        
                        
                        
                        
                        
                        touch $name
                        echo -n "Table Name:"$name >> $name
                        echo  "|Number of Columns:"$Num_col >> $name
                        for item in ${record[@]}
                        do
                            echo -n $item >> $name
                        done
                        echo -n $'\n' >> $name
                        echo  " $name created successfully "
                        
                    else
                        echo -e " \e[1;31mTable $name already exists $reset"
                    fi
                fi
                
                tablesMenu
            ;;
            
            
            
            #INSERTING----------------
            
            3)
                insert() {
                    read -p "insert table name: " tableName
                    if ! [[ -f $tableName ]];
                    then
                        echo -e "\e[1;31m Table not found $reset"
                        
                    else
                        
                        cat $tableName
                        pk(){
                            read -p "enter the primary key: " pk
                            
                            if [[ $pk =~ ^[0-9]*$ ]];
                            then
                                id=($(awk 'BEGIN {FS= "|"} {print $1}' "$tableName" | grep -w "$pk"))
                                
                                if [ -n "$id" ];
                                then
                                    echo -e "\e[1;31m Invalid primary key $reset"
                                    pk
                                else
                                    echo " " >>$tableName
                                    echo -n "$pk">> $tableName
                                    
                                fi
                            else
                                echo "\e[1;31m Please Enter an integer value $reset"
                                pk
                            fi
                        }
                        pk
                        values() {
                            Num_col=$(head -2 $tableName | tail -1 | awk 'BEGIN {FS="|"} {print NF}')
                            
                            for ((i=2; i <= Num_col-1; i++ ));
                            do
                                dtype=$(awk -v n=$i 'BEGIN {FS="|"} NR==2 {print $n}' $HOME/DataBase/$DBname/$tableName | awk 'BEGIN {FS=":"} {print $2}')
                                while true
                                do
                                    read -p "enter the value of col $i: " v
                                    
                                    if [ "$dtype" = "int" ]
                                    
                                    then
                                        if  [[  $v =~ ^[0-9]+$ ]]
                                        then
                                            
                                            echo -n "|" >> $tableName
                                            echo -n "$v" >> $tableName
                                            break
                                        else
                                            echo -e "\e[1;31m Please enter an integer value$reset"
                                        fi
                                        
                                        cat $tableName
                                        
                                    else
                                        echo -n "|" >> $tableName
                                        echo -n "$v" >> $tableName
                                        break
                                    fi
                                done
                            done
                            echo  " " >> $tableName
                            
                        }
                        values
                    fi
                    
                }
                insert
                tablesMenu
            ;;
            
            #SELECTING-------------------------------
            
            4) echo -e "\n \e[1;34m                      -----------------Selecting Menu-----------------    $reset"
                
                select choice in " Select all" "Select from table" " Back to table menu"  "Exit"
                do
                    case $REPLY in
                        1)
                            read -p "Enter the table name: " tableName
                            if [ -f $tableName ]
                            then
                                awk 'NR >1' $HOME/DataBase/$DBname/$tableName
                            else
                                echo -e "\e[1;31mTable doesn't exist $reset"
                            fi
                        ;;
                        
                        2)
                            
                            while true; do
                                read -p  "Enter the name of the table: "  tableName
                                
                                
                                if [ -f $HOME/DataBase/$DBname/$tableName ]; then
                                    while true
                                    do
                                        read -p  "Enter the primary key: " pk
                                        
                                        id=($(awk 'BEGIN {FS= "|"} {print $1}' "$tableName" | grep -w "$pk"))
                                        if [ -n "$id" ]
                                        then
                                            echo "($(awk 'BEGIN {FS= "|"} {print $0}' "$tableName" | grep -w "$pk"))"
                                            
                                            echo -e "\n...........................\n"
                                            
                                            tablesMenu
                                            
                                            break
                                        else
                                            echo -e "\e[1;31m Primary key not found $reset"
                                        fi
                                    done
                                    break
                                else
                                    echo -e "\e[1;31m table not found $reset"
                                fi
                            done
                        ;;
                        3) tablesMenu
                        ;;
                        4) exit
                    esac
                done
            ;;
            
            #DELETING FROM TABLE--------------------------
            5)
                while true; do
                    read -p  "Enter the name of the table: "  tableName
                    
                    
                    if [ -f $HOME/DataBase/$DBname/$tableName ]; then
                        while true
                        do
                            read -p  "Enter the primary key: " pk
                            
                            id=($(awk 'BEGIN {FS= "|"} {print $1}' "$tableName" | grep -w "$pk"))
                            if [ -n "$id" ]
                            then
                                
                                delete=$(awk -v n=$id 'BEGIN { FS="|"}{ if ($1 == n){print NR} }' $HOME/DataBase/$DBname/$tableName)
                                
                                
                                sed -i "$delete d" $HOME/DataBase/$DBname/$tableName
                                
                                echo -e "\e[1;34m Deleted Successfully$reset"
                                
                                echo -e "\n        ...........................\n"
                                tablesMenu
                                
                                break
                            else
                                echo -e "\e[1;31m Primary key not found$reset"
                            fi
                        done
                        break
                    else
                        echo -e "\e[1;31m Table not found$reset"
                    fi
                done
            ;;
            
            #DELETING A TABLE---------------------------
            
            6)
                read -p "Enter name of the table you want to delete: " tableName
                
                if [ -f $tableName ]
                then
                    rm $tableName
                    echo -e "\e[1;34m $tableName Deleted successfully $reset"
                else
                    echo -e "\e[1;31m Table doesn't exist $reset"
                fi
            ;;
            
            
            7) mainMenu ;;
            8) exit ;;
            9)
                
                updateTable(){
                    
                    read -p  "Enter the name of the Table: " tableName
                    if ! [[ -f $tableName ]];then
                        echo -e "\e[1;31m Table not found $reset"
                    else
                        read -p "Enter column name: " col_name
                        
                        Num_col=$(head -2 $tableName | tail -1 | awk 'BEGIN {FS="|"} {print NF}')
                        
                        for ((i=1; i <= Num_col; i++ ));
                        do
                            testcol=$(awk -v n=$i 'BEGIN {FS="|"} (NR==2) {print $n}' $tableName | awk 'BEGIN {FS=":"}{print $1}')
                            
                            datatybecol=$(awk -v n=$i 'BEGIN {FS="|"} (NR==2) {print $n}' $tableName | awk 'BEGIN {FS=":"}{print $2}')

                            
                            if [[ $testcol =  $col_name  ]]
                            then
                                m=$i
                                break
                                echo "$testcol"
                            fi
                            
                        done
                        
                        echo "$testcol"
                        if [[ $testcol == "" ]]
                        then
                            echo -e "\e[1;31m Column not found $reset"
                        else
                            read -p "Enter the Primary Key " pk
                            if [[ -z $pk ]]
                            then
                                echo -e "\e[1;31m Enter a valid pk $reset"
                                read -p "Enter the Primary Key " pk
                            fi
                            id=$(awk 'BEGIN {FS="|"}{if('$pk'==$1) print NR }' $tableName 2>error.log)
                            
                            if [[ $id == "" ]]; then
                                echo -e "\e[1;31m this pk doesn't exist $reset"
                                
                            else
                                
                                read -p "enter newvalue: " newvalue
                                
                                
                                if [[ $m = 1 ]]
                                
                                then
                                    while true
                                    do
                                        uniquePK=$(awk 'BEGIN {FS="|"}{if( $1 == '$newvalue') print NR}' $tableName)
                                        if [[ $uniquePK = "" ]]
                                        then
                                            break
                                        else
                                            
                                            echo -e "\e[1;31m $NewValue exists ,PK should be uniqe $reset"
                                            read -p "enter newvalue: " newvalue
                                            
                                            
                                        fi
                                    done
                                fi
                                
                                
                                
                                if [[ $datatybecol = int ]]; then
                                    check=true
                                    while $check
                                    do
                                        if [[ $newvalue = +([1-9])*([0-9]) ]]
                                        then
                                            check=false
                                        else
                                            read -p "enter newvalue: " newvalue
                                        fi
                                    done
                                fi
                                prevvalue=$(awk  'BEGIN {FS="|"}{if(NR=='$id') print $'$m'}' $tableName )
                                echo "$prevvalue"
                                
                                sed -i "${id}s/$prevvalue/$newvalue/g" $tableName
                                
                            fi
                        fi
                    fi
                    
                }
                updateTable
            ;;
            
            *) echo -e "\e[1;31m Invalid Option $reset" 
            ;;
            
            
        esac
    done
}
mainMenu