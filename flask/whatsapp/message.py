from tkinter import *


def performGUI():
    app = Tk()

    app.geometry("700x500")

    app.title("برنامج توابل")

    heading = Label(text="توابل السلات المتروكة", fg="white", bg="#cba876", width="500", height="1",
                    font=("Hacen Tunisia", "25"))

    heading.pack()

    # File link
    Label(text="رابط الملف").place(x=300, y=70)
    fileLink = StringVar()
    Entry(textvariable=fileLink, width="30").place(x=300, y=90)

    # File name
    Label(text="إسم الملف").place(x=15, y=70)
    fileName = StringVar()
    Entry(textvariable=fileName, width="30").place(x=15, y=90)

    start_row_number_text = Label(text="ارقام التسلسل من:")
    end_row_number_text = Label(text="ارقام التسلسل إلى:")

    start_row_number_text.place(x=15, y=210)
    end_row_number_text.place(x=15 * 10, y=210)

    start_row_number = IntVar()
    end_row_number = IntVar()

    start_row_entry = Entry(textvariable=start_row_number, width="10")
    end_row_entry = Entry(textvariable=end_row_number, width="10")

    start_row_entry.place(x=15, y=240)
    end_row_entry.place(x=15 * 10, y=240)

    import tkinter as tk

    # Text Widget
    t = tk.Text(app, width=50, height=20, )
    t.place(x=15 * 17, y=140)

    mainloop()


def sendMessage():
    return "Message sending"