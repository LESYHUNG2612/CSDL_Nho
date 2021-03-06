------------------------------------------------
/* Học phần: Cơ sở dữ liệu
   Ngày: 17/04/2020
   Người thực hiện: LÊ SỸ HÙNG
*/
------------------------------------------------
--lenh tao CSDL
CREATE DATABASE LAB02_QUANLYSANXUAT
GO
-- lệnh sư dung 
USE  LAB02_QUANLYSANXUAT
-- Tạo Bảng Tổ SX
CREATE TABLE ToSanXuat
(
MaTSX CHAR(5) PRIMARY KEY,-- khai bao khoa chinh
TenTSX NVARCHAR(10) NOT NULL UNIQUE
)
GO
-- Tao bang Công nhan
CREATE TABLE CongNhan
(
MaCN CHAR(10) PRIMARY KEY,-- khai bao khoa chinh
HoCN NVARCHAR(20) NOT NULL,
TenCN NVARCHAR(10) NOT NULL,
Phai NVARCHAR(10),
NgaySinh DATETIME,
MaTSX CHAR(5) REFERENCES ToSanXuat(MaTSX)--khai bao khoa ngoai
)
GO
-- Tạo Bản San Phẩm
CREATE TABLE SanPham
(
MaSP CHAR(6) PRIMARY KEY,-- khai bao khoa chinh
TenSP NVARCHAR(30) NOT NULL,
DVT NVARCHAR(5),
TienCong INT CHECK (Tiencong > 0)
)
GO
-- Tạo Bảng Thành Phẩm
CREATE TABLE ThanhPham
(
MaCN CHAR(10) REFERENCES CongNhan(MaCN),
MaSP CHAR(6) REFERENCES SanPham(MaSP),
Ngay DATETIME,
SoLuong INT,
PRIMARY KEY(MaCN,MaSP,Ngay)
)
SELECT * FROM ThanhPham 
GO
-- xem Bang
SELECT * FROM ToSanXuat
SELECT * FROM CongNhan
SELECT * FROM SanPham
SELECT * FROM ThanhPham
GO
-- 
INSERT INTO ToSanXuat VALUES ('TS01',N'Tổ 1')
INSERT INTO ToSanXuat VALUES ('TS02',N'Tổ 2')
-- xem bang to san xuat
SELECT * FROM ToSanXuat
GO
-- dinh dang ngay thang
SET DATEFORMAT DMY
-- nhap du lieu cho bang cong nhan
INSERT INTO CongNhan VALUES ('CN001',N'Nguyễn Trường',N'An',N'NAM','12/05/1981','TS01')
INSERT INTO CongNhan VALUES ('CN002',N'Lê Thị Hồng',N'Gấm',N'Nữ','04/06/1980','TS01')
INSERT INTO CongNhan VALUES ('CN003',N'Nguyễn Công',N'Thành',N'Nam','04/05/1981','TS02')
INSERT INTO CongNhan VALUES ('CN004',N'Võ Hữu',N'Hạnh',N'Nam','15/02/1980','TS02')
INSERT INTO CongNhan VALUES ('CN005',N'Lý Thanh',N'Hân',N'Nữ','03/12/1981','TS01')
-- xem bảng cong nhan
SELECT * FROM CongNhan
GO
-- Nhap du lieu cho bang san pham
INSERT INTO SanPham VALUES ('SP001',N'Nồi đất',N'Cái','10000')
INSERT INTO SanPham VALUES ('SP002',N'Chén',N'Cái','2000')
INSERT INTO SanPham VALUES ('SP003',N'Bình Gốm Nhỏ',N'Cái','20000')
INSERT INTO SanPham VALUES ('SP004',N'Bình Gốm Lớn',N'Cái','25000')
-- Xem bang san Pham
SELECT * FROM SanPham
GO
SET DATEFORMAT DMY
-- Nhap du lieu cho bang Thanh Pham
INSERT INTO ThanhPham VALUES('CN001','SP001','01/02/2007','10')
INSERT INTO ThanhPham VALUES('CN002','SP001','01/02/2007','5')
INSERT INTO ThanhPham VALUES('CN003','SP002','10/01/2007','50')
INSERT INTO ThanhPham VALUES('CN004','SP003','12/01/2007','10')
INSERT INTO ThanhPham VALUES('CN005','SP002','12/01/2007','100')
INSERT INTO ThanhPham VALUES('CN002','SP004','13/02/2007','10')
INSERT INTO ThanhPham VALUES('CN001','SP003','14/02/2007','15')
INSERT INTO ThanhPham VALUES('CN003','SP001','15/01/2007','20')
INSERT INTO ThanhPham VALUES('CN003','SP004','14/02/2007','15')
INSERT INTO ThanhPham VALUES('CN004','SP002','30/01/2007','100')
INSERT INTO ThanhPham VALUES('CN005','SP003','01/02/2007','50')
INSERT INTO ThanhPham VALUES('CN001','SP001','20/02/2007','30')
-- xem du lieu vua nhap 
SELECT * FROM ThanhPham
GO
--1 Liệt kê các công nhân theo tổ sản xuất gồm các thông tin: 
--TenTSX, HoTen, NgaySinh, Phai (xếp thứ tự tăng dần của tên 
--tổ sản xuất, Tên của công nhân

SELECT ToSanXuat.TenTSX,HoCN+' '+TenCN AS HoVaTen,CONVERT(char(10),NgaySinh, 103),Phai
FROM ToSanXuat,CongNhan 
WHERE ToSanXuat.MaTSX = CongNhan.MaTSX
ORDER BY TenTSX,TenCN,HoCN
GO
--2/ Liệt kê các thành phẩm mà công nhân ‘Nguyễn Trường An’
-- đã làm được gồm các thông tin: TenSP, Ngay, SoLuong,
-- ThanhTien (xếp theo thứ tự tăng dần của ngày). 
SET DATEFORMAT DMY
SELECT B.TenSP,CONVERT(char(10),Ngay, 103),SoLuong,SoLuong*TienCong AS ThanhTien
FROM CongNhan A, ThanhPham C,SanPham B
WHERE A.MaCN =C.MaCN AND C.MaSP = B.MaSP
 AND HoCN = N'Nguyễn Trường' AND TenCN = N'An'
GROUP BY C.Ngay,B.TenSP,C.SoLuong,B.TienCong
GO
--3/ Liệt kê các nhân viên không sản xuất sản phẩm ‘Bình gốm lớn’. 
SELECT *
FROM CongNhan
WHERE CongNhan.MaCN NOT IN(SELECT ThanhPham.MaCN
							FROM SanPham,ThanhPham
							WHERE SanPham.MaSP = ThanhPham.MaSP
									AND SanPham.TenSP =N'Bình Gốm Lớn')
GO
--4/Liệt kê thông tin các công nhân có sản xuất 
--cả ‘Nồi đất’ và ‘Bình gốm nhỏ’.
SELECT DISTINCT congNhan.MaCN,HoCN+' '+TenCN AS HOVATEN
FROM CongNhan, ThanhPham, SanPham
WHERE CongNhan.MaCN = ThanhPham.MaCN AND ThanhPham.MaSP = SanPham.MaSP AND TenSP = N'Nồi Đất'
AND CongNhan.MaCN IN (SELECT ThanhPham.MaCN
						FROM ThanhPham, SanPham
						WHERE ThanhPham.MaSP = SanPham.MaSP AND TenSP = N'Bình Gốm Nhỏ')
GO
--5/ Thống kê Số luợng công nhân theo từng tổ sản xuất. 
SELECT CongNhan.MaTSX,TenTSX,COUNT(MaCN) AS SoCN
FROM ToSanXuat,CongNhan
WHERE	CongNhan.MaTSX = ToSanXuat.MaTSX
GROUP BY CongNhan.MaTSX,TenTSX
GO
--6) Tổng số lượng thành phẩm theo từng loại mà mỗi nhân 
--viên làm được (Ho, Ten, TenSP, TongSLThanhPham, TongThanhTien)

SELECT HoCN+' '+TenCN AS HOVATEN,TenSP,SUM(SoLuong) AS TongSLThanhPham,SUM(SoLuong * TienCong) AS TongThanhTien
FROM ThanhPham B , SanPham C,CongNhan A
WHERE A.MaCN = B.MaCN AND B.MaSP = C.MaSP
GROUP BY HoCN,TenCN,TenSP 
GO
--7 Tổng số tiền công đã trả cho công nhân trong tháng 1 năm 2007 

SELECT  SUM(SoLuong*TienCong) AS TienCongDaTra
FROM ThanhPham A,SanPham B
WHERE A.MaSP = B.MaSP 
		AND MONTH(Ngay) = 1 
		AND YEAR(Ngay) = 2007
GO
--8 Cho biết sản phẩm được sản xuất nhiều nhất trong tháng 2/2007
SELECT A.MaSP,TenSP,SUM(SoLuong) AS TongSL
FROM ThanhPham A,SanPham B
WHERE  A.MaSP = B.MaSP
		AND MONTH(Ngay) = 2
		AND YEAR(Ngay) = 2007
GROUP BY A.MaSP,TenSP
HAVING SUM(SoLuong) >= ALL (SELECT SUM(C.SoLuong)
							FROM ThanhPham C
							WHERE  MONTH(Ngay) = 2 AND YEAR(Ngay) = 2007
							GROUP BY C.MaSP )
--9 Cho biết công nhân sản xuất được nhiều ‘Chén’ nhất. 
SELECT A.MaCN,HoCN+' '+TenCN AS HOVATEN,SUM(SoLuong)AS SoLuong
FROM CongNhan A,ThanhPham B,SanPham C
WHERE A.MaCN = B.MaCN AND B.MaSP = C.MaSP
AND TenSP = N'Chén'
GROUP BY A.MaCN,HoCn,TenCN
HAVING SUM(SoLuong) >= ALL (SELECT SUM(D.SoLuong)
							FROM ThanhPham D,SanPham E
							WHERE  D.MaSP = E.MaSP AND TenSP =N'Chén'
							GROUP BY D.MaCN )
GO	
--10 Tiền công tháng 2/2007 của công nhân viên có mã số ‘CN002
SELECT SUM(SoLuong * TienCong) AS TienCong
FROM ThanhPham A,SanPham B
WHERE A.MaSP = B.MaSP 
	AND MONTH( Ngay ) = 2
	AND YEAR( Ngay ) = 2007
	AND MaCN = 'CN002'
GO
--11 Liệt kê các công nhân có sản xuất từ 3 loại sản phẩm 
SELECT A.MaCN,HoCN,TenCN, COUNT(DISTINCT MaSP)
FROM CongNhan A,ThanhPham B
WHERE A.MaCN = B.MaCN
GROUP BY A.MaCN,HoCN,TenCN
HAVING COUNT(DISTINCT MaSP) >= 3
GO
--12 Cập nhật giá tiền công của các loại bình gốm thêm 1000. 
UPDATE SanPham
SET TienCong = TienCong + 1000
WHERE SanPham.MaSP = 'SP003' OR SanPham.MaSP = 'SP004'
SELECT * FROM SanPham
-- Cập nhật lại về Trạng Thái Ban Đầu
UPDATE SanPham
SET TienCong = TienCong - 1000
WHERE SanPham.MaSP = 'SP003' OR SanPham.MaSP = 'SP004'
SELECT * FROM SanPham
GO
--13 Thêm bộ <’CN006’, ‘Lê Thị’, ‘Lan’, ‘Nữ’,’TS02’ > vào bảng CongNhan.
INSERT INTO CongNhan (MaCN,HoCN,TenCN,Phai,MaTSX)
VALUES ('CN006',N'Lê Thị', N'Lan',N'Nữ','TS02');
SELECT * FROM CongNhan
GO
-- Xoa Bộ công nhân Vừa Thêm
DELETE FROM CongNhan
WHERE MaCN = 'CN006'
SELECT * FROM CongNhan
GO
--- ham va thu tuc----
--A. Viết các hàm sau: 
--a. Tính tổng số công nhân của một tổ sản xuất cho trước 
CREATE FUNCTION ufn_CongNhan(@MaTSX CHAR(5))
	RETURNS int
AS
BEGIN
  DECLARE @TongSoCN int
  SELECT @TongSoCN = COUNT(MaTSX)
  FROM CongNhan
  WHERE MaTSX=@MaTSX
  
  RETURN @TongSoCN
END
-----thu nghiem ham
SELECT dbo.ufn_CongNhan('TS01')
---- TEXT-----
GO
SELECT CongNhan.MaTSX,COUNT(MaTSX) AS TongCN
FROM CongNhan
WHERE MaTSX='TS01'
GROUP BY CongNhan.MaTSX
GO
--b. Tính tổng sản lượng sản xuất trong một tháng của một loại sản phẩm cho trước.
CREATE FUNCTION ufn_SoSanLuong(@MaSP CHAR(5))
	RETURNS INT
AS
BEGIN
	DECLARE @TongSL INT
	SELECT @TongSL=SUM(SoLuong)
	FROM ThanhPham
	WHERE MaSP=@MaSP
	---AND MONTH(Ngay)=02
	
	RETURN @TongSL
END
----thu nghiem ham---
SELECT dbo.ufn_SoSanLuong('SP001')
----text lại -----
SELECT MaSP,Ngay,SUM(SoLuong) AS SanLuong
FROM ThanhPham
WHERE MaSP='SP001'
AND MONTH(Ngay)=02
GROUP BY MaSP,Ngay,SoLuong
-- c. Tính tổng tiền công tháng của một công nhân cho trước.
----text lại -----
SELECT ThanhPham.MaSP,Ngay,SUM(SoLuong*TienCong) AS TienCong
FROM ThanhPham,SanPham
WHERE ThanhPham.MaSP=SanPham.MaSP AND ThanhPham.MaSP='SP001'
AND MONTH(Ngay)=02
GROUP BY ThanhPham.MaSP,Ngay,SoLuong
-- d. Tính tổng thu nhập trong năm của một tổ sản xuất cho trước.
SELECT SUM(SoLuong*TienCong) AS ThuNhap
FROM ThanhPham,SanPham,CongNhan
WHERE CongNhan.MaCN=ThanhPham.MaCN AND ThanhPham.MaSP=SanPham.MaSP
AND CongNhan.MaTSX='TS01'
AND YEAR(Ngay)=2007
GROUP BY SoLuong 
--e. Tính tổng sản lượng sản xuất của một loại sản phẩm 
--trong một khoảng thời gian cho trước.
----text lại -----
SELECT SUM(SoLuong) AS TongSanLuong
FROM ThanhPham
WHERE MaSP='SP001'
AND MONTH(Ngay)=02
AND YEAR(Ngay)=2007
-- B. Viết các thủ tục sau:
-- a. In danh sách các công nhân của một tổ sản xuất cho trước.
create proc usp_InDSCongNhan
	@MaTSX char(4)
As
	Select	TenCN,HoCN,TenCN,Phai,NgaySinh,MaTSX
	From	CongNhan
	WHERE MaTSX=@MaTSX
go
--gọi thủ tục usp_InDSKhachHang
exec usp_InDSCongNhan 'TS01' 

-----TEXT------ 
SELECT MaCN,HoCN,TenCN,Phai,NgaySinh,MaTSX
FROM CongNhan
WHERE MaTSX ='TS01'
--b. In bảng chấm công sản xuất trong tháng của một công nhân 
--cho trước (bao gồm Tên sản phẩm, đơn vị tính, số lượng sản 
--xuất trong tháng, đơn  giá, thành tiền). 
SET DATEFORMAT DMY
create proc usp_BangChamCong
	@Ngay char(10)
As
	Select	SUM(SoLuong*TienCong) AS ThanhTien
	From	CongNhan,ThanhPham,SanPham
	WHERE CongNhan.MaCN=ThanhPham.MaCN AND ThanhPham.MaSP=SanPham.MaSP AND MONTH(Ngay)=MONTH(@Ngay)
GO
--- thu lenh---
exec usp_BangChamCong '01/02/2007' 
-----TEXT-----
SELECT SanPham.TenSP,DVT,SoLuong,TienCong,SUM(SoLuong*TienCong) AS ThanhTien
FROM CongNhan,ThanhPham,SanPham
WHERE CongNhan.MaCN=ThanhPham.MaCN AND ThanhPham.MaSP=SanPham.MaSP
AND MONTH(Ngay) = 02
AND YEAR(Ngay)= 2007
AND CongNhan.MaCN='CN001'
GROUP BY  SanPham.TenSP,DVT,SoLuong,TienCong
SELECT*FROM ThanhPham
