--tqs21 Rut Analiz Detay raporu - rutanalizdetay
 declare @ST nvarchar(10)
 declare @ZIYARETPERYOD tinyint
 declare @CARIKOD nvarchar( 25)
 declare @ZIYARETGUN nvarchar( 25)
 set @ZIYARETPERYOD=1
 set @ST ='406'
 set @CARIKOD = 'HT01051'
 set @ZIYARETGUN=3 -- 0 PZT 1 SALI 2 ÇARŞ 3 PERŞ 4 CUMA 5 CERTESİ 6 PZR

 SELECT TOP 100 PERCENT
 cari_RECno AS [msg_S_0088] /* KAYIT NO */ ,
 cari_kod AS [msg_S_1032] /* CARI KODU */ ,
 cari_unvan1 AS [msg_S_1033] /* CARI ÜNVANI */ ,
 cari_unvan2 AS [msg_S_1034] /* CARI ÜNVANI 2 */ ,
 dbo.fn_CariHesapBakiye('',0,cari_kod, '', '' , 0,0 ) AS [msg_S_1530] /* BAKİYE / HAREKET SAYISI */ ,
 dbo.fn_CariHareketTip(cari_hareket_tipi) AS [msg_S_0888] /* HAREKET TİPİ */
 ,ch.cari_temsilci_kodu , (cpt.cari_per_adi +' ' + cpt.cari_per_soyadi) As temsilciadsoyad
 ,ch.cari_Ana_cari_kodu as anacarikod
 ,ch.cari_grup_kodu
 ,anacarich.anacari_grup_kodu
 ,ch.cari_temsilci_kodu 
 ,ch.cari_sektor_kodu 
 ,ch.cari_bolge_kodu
 FROM CARI_HESAPLAR AS ch WITH (NOLOCK)
 LEFT JOIN dbo.CARI_PERSONEL_TANIMLARI As cpt ON ch.cari_temsilci_kodu = cpt.cari_per_kod
 OUTER APPLY (select cari_grup_kodu as anacari_grup_kodu FROM CARI_HESAPLAR ch2 where ch2.cari_kod=ch.cari_Ana_cari_kodu ) as anacarich
 WHERE 1=1 
 and ch.cari_sektor_kodu ='NS'
 ORDER BY cari_kod ASC
