--select cha_kasa_hizkod,cha_kasa_hizmet,max(cha_RECno),cha_tip,max(cha_evrakno_seri),max(cha_evrakno_sira) from [CARI_HESAP_HAREKETLERI]
--GROUP BY cha_kasa_hizkod,cha_kasa_hizmet,cha_tip
--ORDER BY cha_kasa_hizmet

--select cha_cari_cins,max(cha_kod) as cha_kod,max(cha_RECno) cha_recno,max(cha_evrakno_seri),max(cha_evrakno_sira),cha_tip,cha_evrak_tip,cha_cinsi from [CARI_HESAP_HAREKETLERI]
--GROUP BY cha_cari_cins,cha_tip,cha_evrak_tip,cha_cinsi
--ORDER BY cha_kasa_hizmet

--select fn_CariFoy(4, @caricins, @carikod, @grupno, @devirtar, @ilktar, @sontar, @odemeemridegerlemedok, @SomStr)

Select msg_S_0088 as cha_RECno,#msg_S_0200 as col2, * from dbo.fn_CariFoy (N'0',4,N'Z001',NULL,'20171116','20171116','20171231',0,N'') 
Order by [msg_S_0089] /* TARİH */ ,[msg_S_0094] /* EVRAK TİPİ */ ,[msg_S_0090] /* SERİ */ ,[msg_S_0091] /* SIRA */


