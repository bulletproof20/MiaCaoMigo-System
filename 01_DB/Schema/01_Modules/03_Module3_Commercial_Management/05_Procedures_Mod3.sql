create or replace procedure sp_receive_purchase(p_purchase_id int)
language plpgsql as $$
declare
    line record;
    new_stock_id int;
begin
    update purchase set sta_pur = 'received'
    where id_pur = p_purchase_id;

    for line in
        select * from purchase_line where id_pur = p_purchase_id
    loop
        insert into stock (id_pro, bat_sto, qty_sto, ent_dat_sto, val_dat_sto)
        values (line.id_pro, line.bat_pln, line.qty_pln, now(), null)
        returning id_sto into new_stock_id;

        update purchase_line set id_sto = new_stock_id
        where id_pur_lin = line.id_pur_lin;
    end loop;
end;
$$;
