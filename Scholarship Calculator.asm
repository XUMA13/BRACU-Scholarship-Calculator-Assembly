
.model small
.stack 100h

.data
sem db ?
cgpa dw ?
cgpa1 dw ?
cgpa2 db ?
credits dw ?
idx db ? 
buffer  db 6 dup('$') 
credit_msg db 'Total credits completed: $'
prompt_semesters db "Enter number of semesters in two digits (e.g: 02 or 12): $"
prompt_courses db "Enter number of courses taken in this semester: $"
prompt_cgpa db "Enter CGPA for the course: $"
final_cgpa_message db "Your final CGPA is: $"
scholarship_message db "Scholarship Awarded: $"
no_waiver db "No Scholarship$"  
no_credit db "Cannot avail waiver before completing 30 credits$"
waiver_10 db "10% waiver$"
waiver_25 db "25% waiver$"
waiver_50 db "50% waiver$"
waiver_75 db "75% waiver$"
waiver_100 db "100% waiver$"
total_courses db 0      
sum_of_cgpas dw 0        
average_cgpa dw 0        

.code 
Main proc


start: 
    mov ax, @data
    mov ds, ax 
     
    mov ah, 09h
    lea dx, prompt_semesters
    int 21h
    ; Input number of semesters
    mov ah, 01h
    int 21h 
    sub al, '0'
    mov sem, al 
    mov ah, 01h
    int 21h
    sub al, '0'
    mov bl, sem       
    add bl, al  ; number of semesters in BL  
    mov sem, bl



semester_loop:  

    call newline
    mov ah, 09h
    lea dx, prompt_courses
    int 21h

    ; Input number of courses for this semester
    mov ah, 01h
    int 21h
    sub al, '0'      
    mov cl, al        

    mov al, total_courses
    add al, cl
    mov total_courses, al 
    mov dl, 3
    mul dl 
    mov ah, 0
    mov credits, ax

course_loop:

    call newline
    mov ah, 09h
    lea dx, prompt_cgpa
    int 21h

    ; Input CGPA for the course 

    mov ah, 01h 
    
    int 21h
    sub al, 30h
    mov ah, 100 
    mul ah
    mov cgpa1, ax  
    
    mov ah, 01h
    int 21h 
    
    mov ah, 01h
    int 21h
    sub al, 30h
    mov ah, 10
    mul ah

    mov cgpa, ax 
    

    mov ax, cgpa1

    add ax, cgpa
    mov cgpa, ax 
 
    mov dx, cgpa ; Store CGPA in DL


    mov ax, sum_of_cgpas 

    add ax, dx

    mov sum_of_cgpas, ax

    ; Decrement course counter
    dec cl
    jnz course_loop

    ; Decrement semester counter
    dec bl
    jnz semester_loop


    ;average CGPA 
    mov dx,0
    mov ax, sum_of_cgpas
    mov bh, 0
    mov bl, total_courses
    div bx         
    mov average_cgpa, ax
 
    call newline
    mov ah, 09h
    lea dx, final_cgpa_message
    int 21h 
                
    
    
again: 
  
  ;CONVERT average_cgpa TO DECIMAL

  call clear_buffer

  mov ax, average_cgpa                  

  lea  si, buffer
  call number2string    ;STRING RETURNS IN SI (BUFFER).

           

;DISPLAY NUMBER AS STRING.  
  mov al, buffer
  mov idx, al
  mov dl, al
  mov ah, 2
  int 21h 
  
  mov dl, '.'
  int 21h
  
  mov al, buffer[1]

  
  mov dl, al
  mov ah , 2
  int 21h
  
  mov al, buffer[2]
  mov dl, al
  mov ah , 2
  int 21h


jmp do


clear_buffer proc
  lea  si, buffer
  mov  al, '$'
  mov  cx, 5  
clearing:
  mov  [si], al
  inc  si
  loop clearing

  ret
clear_buffer endp


number2string proc
  mov  bx, 10 ;DIGITS ARE EXTRACTED DIVIDING BY 10.
  mov  cx, 0 ;COUNTER FOR EXTRACTED DIGITS.
cycle1:       
  mov  dx, 0
  div  bx 
  push dx ;SAVE DIGIT EXTRACTED FOR LATER.
  inc  cx ;INCREASE COUNTER FOR EVERY DIGIT EXTRACTED.
  cmp  ax, 0  ;IF NUMBER IS
  jne  cycle1 ;NOT ZERO, LOOP. 
;RETRIEVE PUSHED DIGITS.
  lea  si, buffer 

cycle2:  
  pop  dx        
  add  dl, 48 ;CONVERT DIGIT TO CHARACTER.
  mov  [ si ], dl
  inc  si
  loop cycle2  

  ret 
  
number2string endp  

  ;CONVERT credits TO DECIMAL
do:                    
                    
    call newline
    mov ah, 09h
    lea dx, credit_msg
    int 21h
 

  call clear_buffers
  mov ax, credits
                      

  lea  si, buffer
  call num2string

           
  mov al, buffer
  mov idx, al
  mov dl, al
  mov ah, 2
  int 21h 
  
  
  mov al, buffer[1]

  
  mov dl, al
  mov ah , 2
  int 21h
  

jmp here


clear_buffers proc
  lea  si, buffer
  mov  al, '$'
  mov  cx, 5  
clear:
  mov  [si], al
  inc  si
  loop clear

  ret
clear_buffers endp



num2string proc
  mov  bx, 10 ;DIGITS ARE EXTRACTED DIVIDING BY 10.
  mov  cx, 0 ;COUNTER FOR EXTRACTED DIGITS.
cycles1:       
  mov  dx, 0
  div  bx 
  push dx ;SAVE DIGIT EXTRACTED FOR LATER.
  inc  cx ;INCREASE COUNTER FOR EVERY DIGIT EXTRACTED.
  cmp  ax, 0  ;IF NUMBER IS
  jne  cycles1 ;NOT ZERO, LOOP. 
;RETRIEVE PUSHED DIGITS.
  lea  si, buffer 

cycles2:  
  pop  dx        
  add  dl, 48 ;CONVERT DIGIT TO CHARACTER.
  mov  [ si ], dl
  inc  si
  loop cycles2  

  ret 
  
num2string endp  
                      
                        
here:                    
    call newline
    mov ah, 09h
    lea dx,scholarship_message
    int 21h 
    
    ;scholarship eligibility
    
    mov ax, credits
    cmp ax, 1Eh
    jl no_scholar
                                     
                                     
    mov ax, average_cgpa
    
    cmp ax, 190h
    je scholarship_100  ; CGPA = 4.0   
    
    cmp ax, 18Bh        ; CGPA >= 3.95 and < 4.0
    jge scholarship_75 
    
    cmp ax, 186h        ; CGPA >= 3.9 and < 3.95
    jge scholarship_50
    
    cmp ax, 181h        ; CGPA >= 3.85 and < 3.9
    jge scholarship_25
    
    cmp ax, 17Ch        ; CGPA >= 3.8 and < 3.85
    jge scholarship_10 
    
     
    cmp ax, 17Ch        ; CGPA < 3.8
    jl no_scholarship
    
    
scholarship_100: 
    mov ah, 09h
    lea dx, waiver_100
    int 21h
    jmp end_program

scholarship_75:
    mov ah, 09h 
    lea dx, waiver_75
    int 21h
    jmp end_program

scholarship_50: 


    mov ah, 09h
    lea dx, waiver_50
    int 21h
    jmp end_program

scholarship_25: 
 

    mov ah, 09h
    lea dx, waiver_25
    int 21h
    jmp end_program

scholarship_10: 

    mov ah, 09h
    lea dx, waiver_10
    int 21h
    jmp end_program

no_scholarship:

    mov ah, 09h
    lea dx, no_waiver
    int 21h
    jmp end_program
    
no_scholar: 
    mov ah, 09h
    lea dx, no_credit
    int 21h
    jmp end_program    
    
newline proc
    mov ah, 2     
    mov dl, 10d      
    int 21h        
    mov dl, 13d      
    int 21h  
    ret
           
newline ENDP
  

end_program:

    mov ah, 4Ch
    int 21h
end start








