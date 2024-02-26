library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;


entity contatore is
port(
i_clk: in std_logic;
i_rst: in std_logic;
i_ec: in std_logic;
i_k: in std_logic_vector (9 downto 0);
i_j: in std_logic_vector (9 downto 0);

o_j: out std_logic_vector (9 downto 0)
);
end contatore;

architecture contatore_arch of contatore is

begin
process(i_clk, i_rst, i_j, i_k, i_ec)
begin
if (i_clk'event and i_clk='1') then 
    if (i_rst='1' or i_j=i_k) then
        o_j <= (others => '0');
    elsif (i_ec = '1') then
        o_j <= std_logic_vector(UNSIGNED(i_j) + 1);
    end if;
end if;

end process;

end;
