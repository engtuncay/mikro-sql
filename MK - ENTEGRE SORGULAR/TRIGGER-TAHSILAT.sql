CREATE TRIGGER XOZ_CHH_FORDELETE ON dbo.CARI_HESAP_HAREKETLERI
FOR UPDATE,DELETE
AS
BEGIN

DECLARE @evraktip int
SELECT @evraktip =  cha_evrak_tip FROM DELETED

DECLARE @chatip int
SELECT @chatip = cha_tip FROM DELETED

DECLARE @cha_normal_Iade  int
SELECT @cha_normal_Iade = cha_normal_Iade FROM DELETED

DECLARE @cha_cinsi int
SELECT @cha_cinsi = cha_cinsi FROM DELETED

DECLARE @idislem int

select @idislem = ci.chaislemid FROM [XOZ_CARIHAREKETCINSDETAY] ci where
ci.cinsi = @cha_cinsi and ci.evraktip= @evraktip and ci.cha_tip = @chatip
and ci.cha_normal_Iade = @cha_normal_Iade

IF NOT @idislem=23 
BEGIN
GOTO TRIGGERSON
END


DECLARE @tarih as datetime
SELECT @tarih =  cha_tarihi FROM DELETED

--SELECT cha_tarihi FROM [CARI_HESAP_HAREKETLERI] 

DECLARE @onay as int
SELECT @onay = count(*) from [XozIslemGunKumulatif] igk WHERE igk.bitOnayli=1 and igk.dateislem= @tarih and igk.idislemtip=23

IF @onay>0
BEGIN
RAISERROR('KREDİ KARTI GÜN TOPLAMI ONAYLANDIĞI İÇİN SİLİNEMEZ.', 16, 1)
ROLLBACK
RETURN
END

TRIGGERSON:

END