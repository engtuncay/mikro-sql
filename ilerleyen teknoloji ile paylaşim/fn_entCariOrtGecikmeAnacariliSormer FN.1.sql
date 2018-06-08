


select ch.cari_kod, 'PANEK' as SM, meblag,x.gecikme21,x.gecikme30,x.gecikme45,x.gecikme60,y.cari_temsilci_kodu
,dbo.fn_entCariOrtGecikmeAnacariliSormer('KM102','PANEK') as gecikme from CARI_HESAPLAR ch 
CROSS APPLY fn_entCariGunGecikmeAnacariliTbl(ch.cari_kod, 1, '') as x
OUTER APPLY ( select TOP 1 cari_temsilci_kodu from [CARI_HESAPLAR] 
WHERE cari_Ana_cari_kodu=ch.cari_kod and cari_temsilci_kodu<>'' and cari_temsilci_kodu IS NOT NULL ) as y
where ch.cari_kod = 'KM102'  -- KENT KM102 45 GÜN



select ch.cari_kod,y.cari_temsilci_kodu from CARI_HESAPLAR ch 
OUTER APPLY ( select TOP 1 cari_temsilci_kodu from [CARI_HESAPLAR] 
WHERE cari_Ana_cari_kodu=ch.cari_kod and cari_temsilci_kodu<>'' and cari_temsilci_kodu IS NOT NULL and cari_sektor_kodu='KENT' ) as y
WHERE ch.cari_kod = 'MK001'