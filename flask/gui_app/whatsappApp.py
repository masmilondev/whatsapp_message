from tkinter import *
from utils import Utils
from enums import FileType

class Main(Utils):
    def __init__(self, file, fileName = "customers", type=FileType.Customer, start = 0, end = 0):
        super().__init__(file, fileName, start, end, type)

def performGUI():
    app = Tk()

    app.geometry("700x500")
    
    app.title("برنامج توابل")

    heading = Label(text="توابل السلات المتروكة",fg="white",bg="#cba876",width="500",height="1", font=("Hacen Tunisia", "25"))

    heading.pack()

    # File link
    Label(text="رابط الملف").place(x=300,y=70)
    fileLink = StringVar()
    Entry(textvariable=fileLink, width="30").place(x=300,y=90)
    

    # File name
    Label(text="إسم الملف").place(x=15,y=70)
    fileName = StringVar()
    Entry(textvariable=fileName, width="30").place(x=15,y=90)
    

    start_row_number_text = Label(text="ارقام التسلسل من:")
    end_row_number_text = Label(text="ارقام التسلسل إلى:")
    
    start_row_number_text.place(x=15,y=210)
    end_row_number_text.place(x=15 * 10,y=210)
    
    start_row_number = IntVar()
    end_row_number = IntVar()

    start_row_entry = Entry(textvariable=start_row_number,width="10")
    end_row_entry = Entry(textvariable=end_row_number,width="10")
    

    start_row_entry.place(x=15,y=240)
    end_row_entry.place(x=15 * 10,y=240)


    import tkinter as tk


    # Text Widget
    t = tk.Text(app, width=50, height=20,)
    t.place(x=15 * 17,y=140)


    buttonMaxRow = Button(app, text="Remove duplicate", command= lambda: Main(file = fileLink.get(),fileName=fileName.get(), type=FileType.abandoned).removeDuplicate, width="18",height="1",bg="#cba876", fg="white", font=("Hacen Tunisia", 15, 'bold'), borderwidth = '4')
    buttonMaxRow.place(x=15,y=320)

    button = Button(app,text="ارسل رسالة", command= lambda: Main(file = fileLink.get(),fileName=fileName.get(), type=FileType.Customer).sendMessage(t.get(1.0,END)), width="18",height="1",bg="#cba876", fg="white", font=("Hacen Tunisia", 15, 'bold'), borderwidth = '4')

    button.place(x=15,y=400)

    mainloop()

# performGUI()