use master
go
create database example10
go
use example10
go
create table Classes
(
    ClassID int identity,
	ClassName nvarchar(10),
	constraint PK_Classes PRIMARY KEY(ClassID),
	constraint UQ_ClassesClassName UNIQUE(ClassName)
)
create table Students
( 
    RollNo varchar(6) constraint PK_Students PRIMARY KEY,
	FullName nvarchar(50) not null,
	Email varchar(100) constraint UQ_StudentsEmail UNIQUE,
	ClassName nvarchar(10) constraint FK_Students_Classes FOREIGN KEY REFERENCES Classes(ClassName) on UPDATE CASCADE
)
go
CREATE INDEX IX_Email ON Students(Email)
--Tạo bảng subjects
create table Subjects
(
     SubjectID int,
	 SubjectName nvarchar(100)
)
--Tạo chỉ mục Clustered
create clustered index IX_SubjectID
ON Subjects(SubjectID)
--Tạo chỉ mục Nonclustered
create nonclustered index IX_SubjectName
ON Subjects(SubjectName)
--Tạo chỉ mục duy nhất 
create unique index IX_UQ_SubjectName ON Subjects(SubjectName)
--Tạo chỉ mục kết hợp
CREATE INDEX IX_Name_Email ON Students(FullName,Email)

go
--xóa chỉ mục IX_SubjectID
DROP INDEX IX_SubjectID ON Subjects
go
--Tạo chỉ mục IX_SubjectID mới với tùy chọn FILLFACTOR
CREATE CLUSTERED index IX_SubjectID ON Subjects(SubjectID) with(fillfactor=60)

--xóa chỉ mục IX_SubjectID
DROP INDEX IX_SubjectID on Subjects
go

--tạo chỉ mục IX_SUbjectID mới với tùy chọn PAD_INDEX và Fillfactor
create clustered index IX_SubjectID on Subjects(SubjectID) with(PAD_INDEX=on, fillfactor=60)
go
--xem định nghĩa chỉ mục dùng sp_helptext
exec sp_helptext 'Subjects'
----hoặc
execute sp_helpindex 'Subjects'
go
--xây dựng lại chỉ mục IX_SubjecName
alter index IX_SubjectName ON Subjects rebuild
--xây dụng lại chỉ mục IX_SubjectName với tùy chọn Fillfactor
alter index IX_SubjectName ON Subjects rebuild with(fillfactor=60)

--vô hiệu hóa chỉ mục IX_SubjectName
alter index IX_SubjectName ON Subjects Disable
--xây dựng lại chỉ mục IX_SubjectName tương đương làm cho chỉ mục có hiệu lực
alter index IX_SubjectName ON Subjects rebuild
--làm chỉ mục IX_SubjectName tổ chức lại
alter index IX_SubjectName ON Subjects reorganize
--thay đổi chỉ mục IX_SubjectName thành ONLINE chỉ áp dụng trên bản Enterprise
alter index IX_SubjectName ON Subjects rebuild with(online=on)
--thao tác với chỉ mục song song
alter index IX_SubjectName ON Subjects rebuild with(maxdop=4)

--chỉ mục với nhiều cột
create index IX_FullName_Include ON Students(FullName) INCLUDE(Email,ClassName)
--Truy vấn sau về sử dụng chỉ mục IX_FullName_Include:
select FullName,Email, CLassName from Students where FullName like '%a%'
--xóa chỉ mục
drop index IX_FullName_Include ON Students
--tạo thống kê chỉ mục 
Create Statistics Statictics_Subjects ON Subjects(SubjectID)
--cập nhật thống kê chỉ mục
update statistics Subjects Statictics_Subjects
--xem thống kê chỉ mục
dbcc Show_statistics(Subjects, Statictics_Subjects)
