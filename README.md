# CGPA Calculator with Scholarship Eligibility - Intel 8086 Assembly

## 📌 Project Overview
This project is a **CGPA calculator** written in **Intel 8086 Assembly Language** using the **EMU8086 emulator**. It calculates a student's **Cumulative Grade Point Average (CGPA)** based on the number of semesters, courses per semester, and individual course CGPA inputs. The program also determines **scholarship eligibility** based on predefined CGPA ranges.

## 🏗️ Features
This program includes the following key features:

1. **User Input for Semesters & Courses**  
   - User enters the total number of semesters.  
   - For each semester, the user inputs the number of courses taken.  

2. **CGPA Input & Storage**  
   - The CGPA for each course is taken as input.  
   - The CGPA values are stored in an **array** for efficient processing.  

3. **Final CGPA Calculation**  
   - The total CGPA sum is computed.  
   - The **final CGPA** is calculated by dividing the total sum by the total number of courses.  

4. **Scholarship Eligibility Check**  
   - Scholarship is awarded based on the final CGPA:  

   | **CGPA Range**       | **Scholarship** |
   |-----------------------|-----------------|
   | Less than 3.8         | No Scholarship  |
   | 3.8 - 3.85            | 10%            |
   | 3.85 - 3.9            | 25%            |
   | 3.9 - 3.95            | 50%            |
   | 3.95 - 3.99           | 75%            |
   | 4.0                   | 100%           |

5. **Total Credits Calculation**  
   - The program calculates the total **academic credits completed** based on the number of courses.  
   - A **minimum of 30 credits** is required for scholarship eligibility.  

6. **Final Output Display**  
   - The program displays:  
     - The **final CGPA** in decimal format.  
     - The **total credits completed**.  
     - The **scholarship percentage** (if eligible).  

---

## 🛠️ Installation & Setup
To run this program, follow these steps:

### **1️⃣ Install EMU8086 Emulator**
- Download and install **EMU8086** from: [emu8086.com](https://emu8086.com/)  

### **2️⃣ Load & Run the Program**
- Open the emulator.  
- Copy the **assembly code** from `cgpa_calculator.asm`.  
- Paste it into a new file in EMU8086.  
- Assemble and run the code.  

### **3️⃣ Provide Input**
- The program will prompt for **semesters, courses, and CGPA per course**.  
- Enter values as **single digits** (e.g., `4` for CGPA 4.0).  

### **4️⃣ View Output**
- The program calculates **CGPA** and displays **scholarship status**.  

---

## 📜 Code Explanation
The program is structured into **six main sections**, making it easy to understand and modify.

### **🔹 1. Input Semesters & Courses**
```assembly
mov ah, 09h
lea dx, prompt_semesters
int 21h

mov ah, 01h
int 21h
sub al, '0'
mov sem, al 
