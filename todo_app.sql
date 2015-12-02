DROP TABLE tasks;

CREATE TABLE tasks (
  id SERIAL8 primary key,
  name VARCHAR(255),
  details text,
  modified timestamp default current_timestamp
);


CREATE OR REPLACE FUNCTION update_modified_column() 
RETURNS TRIGGER AS $$
BEGIN
    NEW.modified = now();
    RETURN NEW; 
END;
$$ language 'plpgsql';

CREATE TRIGGER update_tasks_modtime BEFORE UPDATE ON tasks FOR EACH ROW EXECUTE PROCEDURE  update_modified_column();