alter table time_entry add column notes TEXT;

ALTER TABLE system ADD COLUMN xero_client_id VARCHAR(255);
ALTER TABLE system ADD COLUMN xero_client_secret VARCHAR(255);
ALTER TABLE system ADD COLUMN sim_card_no int;

