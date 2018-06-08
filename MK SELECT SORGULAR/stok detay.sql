SELECT
sto_kod,
sto_isim As [#msg_S_0002] /* STOK İSMİ */ ,
sto_birim1_ad,
sto_birim2_ad,
sto_birim3_ad,
sto_birim4_ad,
CASE WHEN sto_birim2_katsayi>=0 THEN sto_birim2_katsayi ELSE 1.0/ABS(sto_birim2_katsayi) END AS BIRIM_2_CARPAN,
CASE WHEN sto_birim3_katsayi>=0 THEN sto_birim3_katsayi ELSE 1.0/ABS(sto_birim3_katsayi) END AS BIRIM_3_CARPAN
FROM dbo.STOKLAR WITH (NOLOCK)
WHERE sto_sektor_kodu='PANEK'

SELECT TOP 10 
*
FROM dbo.STOKDETAY
ORDER BY [msg_S_0001] /* STOK KODU */