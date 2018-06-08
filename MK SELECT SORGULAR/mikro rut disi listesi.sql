-- tag: outer-apply, rutdisi
-- tqs 040118-0945
Declare @limit as float = 0.25

select rutdisi.cari_kod as cari_kod, rutdisi.cari_unvan1 as cari_unvan1, rutdisi.cari_bolge_kodu as cari_bolge_kodu
,bakiye as nCariBakiyetr 
,satici.cha_satici_kodu as cha_satici_kodutr 
,cpt.cari_per_adi as cari_per_aditr
,rutdisi.cari_temsilci_kodu as cari_temsilci_kodu , rutdisi.cari_sektor_kodu as cari_sektor_kodu
 from
 (
 SELECT cari_kod ,cari_unvan1 ,cari_bolge_kodu,ch.cari_sektor_kodu,ch.cari_temsilci_kodu  
 FROM dbo.CARI_HESAPLAR AS ch WITH ( NOLOCK )
 WHERE ch.cari_temsilci_kodu='' or ch.cari_temsilci_kodu is null  -- temsilci tanımı
 or ch.cari_bolge_kodu NOT IN ( '1', '2' ,'3','4','5','6','7','8') -- gün tanımı
 or ch.cari_sektor_kodu is null or ch.cari_sektor_kodu=''    --sor mer tanımı
 ) as rutdisi
 OUTER APPLY (select dbo.fn_CariHesapBakiye( '', 0,rutdisi.cari_kod, '', '' , 0 ,0 ) as bakiye
 ) as chbakiye
 OUTER APPLY (select top 1 chh.cha_satici_kodu from [CARI_HESAP_HAREKETLERI] as chh WITH ( NOLOCK)
 where chh.cha_kod= rutdisi.cari_kod order by cha_RECno desc ) as satici -- as satici on 1=1
 LEFT JOIN CARI_PERSONEL_TANIMLARI As cpt WITH ( NOLOCK) ON satici.cha_satici_kodu = cpt.cari_per_kod
 WHERE (bakiye> @limit or bakiye < (@limit*-1)) and rutdisi.cari_sektor_kodu = 'NESTLE'
 ORDER BY bakiye desc
 
 
 --FROM dbo.CARI_HESAPLAR AS ch WITH ( NOLOCK )
 --LEFT JOIN dbo.CARI_HESAP_ADRESLERI AS ca WITH ( NOLOCK) ON ch.cari_kod = ca.adr_cari_kod