-- tqs 040118-1449
--select cari_sektor_kodu,cari_kod,cari_unvan1,* from [CARI_HESAPLAR]--
--where NOT (cari_sektor_kodu='DG' or cari_sektor_kodu='NS' or cari_sektor_kodu='KN' or cari_sektor_kodu='OZ' or cari_sektor_kodu='HT' or cari_sektor_kodu='PN')

select rutdisi.cari_kod as carikod,chh.seri, chh.sira, rutdisi.cariunvan as cariunvan1,bakiye,chh.saticikodu,cpt.cari_per_adi as cariperadi,rutdisi.ziyaretgun
,rutdisi.cari_temsilci_kodu, rutdisi.cari_bolge_kodu, rutdisi.cari_sektor_kodu 
 FROM (SELECT TOP 100 PERCENT
 cari_kod AS cari_kod /* [msg_S_1032] CARI KODU */ ,
 cari_unvan1 AS cariunvan /*[msg_S_1033] CARI ÜNVANI */
 ,ch.cari_bolge_kodu as ziyaretgun
 ,ch.cari_sektor_kodu
 ,ch.cari_temsilci_kodu
 ,ch.cari_bolge_kodu
  FROM dbo.CARI_HESAPLAR AS ch WITH ( NOLOCK )
 --LEFT JOIN dbo.CARI_HESAP_ADRESLERI AS ca WITH ( NOLOCK) ON ch.cari_kod = ca.adr_cari_kod
 WHERE (NOT (cari_sektor_kodu='DG' or cari_sektor_kodu='NS' or cari_sektor_kodu='KN' or cari_sektor_kodu='HT' or cari_sektor_kodu='PN' or cari_sektor_kodu='MK')) or cari_sektor_kodu is null
 ) as rutdisi
 OUTER APPLY (select dbo.fn_CariHesapBakiye( '', 0,rutdisi.cari_kod, '', '' , 0 ,0 ) as bakiye
 ) as chbakiye
 OUTER APPLY (select top 1 chh.cha_satici_kodu as saticikodu, chh.cha_evrakno_seri as seri, chh.cha_evrakno_sira as sira from [CARI_HESAP_HAREKETLERI] as chh WITH ( NOLOCK)
 where chh.cha_kod= rutdisi.cari_kod order by cha_RECno desc ) as chh
 -- as satici on 1=1
 LEFT JOIN CARI_PERSONEL_TANIMLARI As cpt WITH ( NOLOCK) ON chh.saticikodu = cpt.cari_per_kod
 WHERE bakiye> 0.25 or bakiye < (- 0.25 )
 ORDER BY bakiye desc
 
 --update [CARI_HESAPLAR] set cari_sektor_kodu='XX'  where cari_kod='XX'