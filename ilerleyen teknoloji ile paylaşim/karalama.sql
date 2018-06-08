
--select top 50 sto_kod,sto_isim,sto_kisa_ismi,dbo.fn_entstokbirimMaliyetSonDurum(sto_kod) as alisFiyat from STOKLAR where sto_sektor_kodu='PANEK'  
--select TOP 500 * from [STOK_HAREKETLERI_VIEW_WITH_INDEX_03] --where sth_evraktip='4' and sth_evrakno_seri='PN' AND sth_evrakno_sira='11644877'

--Select * FROM dbo.StokEnvanterYonetimi('20180401','20180401',0,N'901',0,0)

--selett * FROM dbo.HamStokEnvanterYonetimi(@ilktar,@sontar,@doviz,@depolarstr,@depolartekdepo,@partidetayli)
--select * FROM dbo.fn_Stok_Giris_Cikis('',null,@sontar,@depolartekdepo)


--IF object_id(N'dbo.fn_entGecikmeGunAnacarili', N'FN') IS NOT NULL 
 --   DROP FUNCTION dbo.fn_entGecikmeGunAnacarili

--FN = Scalar Function
--IF = Inlined Table Function
--TF = Table Function
