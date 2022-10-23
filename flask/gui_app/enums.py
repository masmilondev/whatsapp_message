import enum

class FileType(enum.Enum):
    Customer = 1
    abandoned = 2
    newSheet = 3
    oldSheet = "Sheet1"
    errorSheet = 4
    successSheet = 5