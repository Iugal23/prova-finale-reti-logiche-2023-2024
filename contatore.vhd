library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;


entity contatore is
port(
i_clk: in std_logic;
i_rst: in std_logic;
i_ec: in std_logic;
i_k: in std_logic_vector (9 downto 0);

o_j: out std_logic_vector (9 downto 0)

);
signal cnt:std_logic_vector (9 downto 0);
end contatore;

architecture contatore_arch of contatore is

begin

process(i_clk,i_rst,cnt,i_k)
variable temp: unsigned (9 downto 0);
begin
temp:=unsigned(cnt);
if (i_rst='1' or UNSIGNED(cnt)=2*UNSIGNED(i_k)+1) then
        cnt <= (others => '0');
elsif (i_clk'event and i_clk='1') then 
    if (i_ec = '1') then
        cnt <= std_logic_vector(temp + 1);
    end if;
end if;
end process;
o_j<=cnt;
end;