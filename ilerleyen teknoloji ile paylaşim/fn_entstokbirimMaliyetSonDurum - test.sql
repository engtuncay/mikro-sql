
select top 50 sto_kod,sto_isim,sto_kisa_ismi,dbo.fn_entstokbirimMaliyet(sto_kod) as birimMaliyet from STOKLAR where sto_sektor_kodu='PANEK'
