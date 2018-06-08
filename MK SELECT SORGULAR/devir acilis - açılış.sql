USE MikroDB_V15_OZPAS
--select * from [XOZ_MODDEVIR_ACILIS] ac where ac.intislemid=18
DECLARE @srmkodu varchar(10) = 'PANEK'
DECLARE @intacilistur tinyint = 1 --1 pano,0 mikro
DECLARE @kayittarih datetime = GETDATE ()
DECLARE @dbltutar numeric( 15,5 ) = 0
DECLARE @devirtarih nvarchar( 15) = '20170101' -- :tarih
DECLARE @intislemid tinyint = 30
-- DOGUS KENT OZPAS NESTLE KRAFT HAYAT --:srmkodu
select * from [XOZ_MODDEVIR_ACILIS] where strsomkod=@srmkodu --and intislemid=1 

--INSERT INTO [XOZ_MODDEVIR_ACILIS]
--(intislemid, datetarih, dblacilistutar, bitiptal, datechanged, datecreated, intacilistur, strsomkod)
--VALUES (@intislemid , @devirtarih, @dbltutar , 0, @kayittarih,@kayittarih, @intacilistur, @srmkodu )


