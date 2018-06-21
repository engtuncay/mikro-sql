select  
cari_kod as "Müşteri Kodu"
,cari_unvan1 as "Ünvan"
,cari_unvan2 as "İlgili Kişi"
,ca.adr_cadde as "Adres"
,ca.adr_il as "Şehir"
,ca.adr_ilce as "İlçe"
,'2' as "Calisma Tipi" -- alıcı,satıcı hepsi
,ch.cari_vdaire_adi as "Vergi Dairesi"
,ch.cari_vdaire_no as "Vergi Numarası"
,ch.cari_vdaire_no as "Tc No"
,'' as "Müşteri Grubu"
,'' as "Müşteri Ek Grubu"
,'0' as "Ödeme Tipi" -- peşin
,cari_unvan1 as "Kısa Adı"
,'0' as "Müşteri Tipi" -- 0:normal
,CASE LEN(ch.cari_vdaire_no)
WHEN 11 THEN '2'
WHEN 10 THEN '3'
END as "Vergi Tipi"  -- 2:gerçek kişi:vd ve vergi no içeri alınır,3:tüzel kişi 1:kdv den muaf  0:vergi no girmek zorunda degil vd ve tcno içeri alınır
,'0' as "Uygulama Yeri" -- 0: panorama
--,cari_temsilci_kodu,cari_sektor_kodu,cari_grup_kodu,cari_bolge_kodu 
from [CARI_HESAPLAR] ch
LEFT JOIN [CARI_HESAP_ADRESLERI] ca ON ch.cari_kod = ca.adr_cari_kod
where cari_sektor_kodu='PANEK' --AND cari_kod='PN106594'


