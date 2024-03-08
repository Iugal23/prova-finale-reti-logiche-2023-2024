library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;


entity fsm is
port(
i_start: in std_logic;
i_clk: in std_logic;
i_rst: in std_logic;
i_add: in std_logic_vector (15 downto 0);
i_k: in std_logic_vector (9 downto 0);
i_j: in std_logic_vector (10 downto 0);
i_mem_data: in std_logic_vector (7 downto 0);

o_done: out std_logic;
o_mem_we: out std_logic;
o_mem_en: out std_logic;
o_ec: out std_logic;
o_mem_add: out std_logic_vector (15 downto 0);
o_mem_data: out std_logic_vector (7 downto 0)
);
end fsm;

architecture fsm_arch of fsm is
type state_type is (s0, s1, s2, s3, s4, s5, s6, s7, s8, s9);
signal CURRENT_STATE, NEXT_STATE: state_type;
begin
combin: process (i_clk, i_rst,CURRENT_STATE,i_start,i_k,i_mem_data, i_j, i_add)
begin
--o_done<='0';
--o_ec<='0';
--o_mem_en<='0';
--o_mem_we<='0';
    if(i_rst='1')then
        CURRENT_STATE <= s0;
        o_done <= '0';
        o_mem_en <= '0';
        o_mem_we <= '0';
        o_ec <= '0'; 
        o_mem_add <= (others => '0');
        o_mem_data <= (others => '0');
    elsif(i_clk'event and i_clk='1')then  
         CURRENT_STATE<= NEXT_STATE; 
    end if;
    case CURRENT_STATE is
        when s0 =>
            if (i_start = '1') then
                o_mem_we <= '0';
                o_mem_en <= '0';
                o_ec <= '0';
                o_done <= '0';
                o_mem_add <= (others => '0');
                o_mem_data <= (others => '0');
                NEXT_STATE <= s1;
            else 
                o_mem_we <= '0';
                o_mem_en <= '0';
                o_ec <= '0';
                o_done <= '0';
                o_mem_add <= (others => '0');
                o_mem_data <= (others => '0');
                NEXT_STATE <= s0;
            end if;
        when s1 =>
            if (i_start = '1' and unsigned(i_j)=2*unsigned(i_k)) then
                o_mem_en <= '0';
                o_mem_we <= '0';
                o_ec <= '0';
                o_done <= '1';
                o_mem_add <= (others => '0');
                o_mem_data <= (others => '0');
                NEXT_STATE <= s7;
            elsif (i_start = '1') then
                o_mem_we <= '0';
                o_mem_en <= '1';
                o_mem_add <= std_logic_vector(UNSIGNED(i_add)+UNSIGNED(i_j));
                o_ec <= '1';
                o_done <= '0';
                o_mem_data <= (others => '0');
                NEXT_STATE <= s2;
            else 
                o_mem_we <= '0';
                o_mem_en <= '0';
                o_ec <= '0';
                o_done <= '0';
                o_mem_add <= (others => '0');
                o_mem_data <= (others => '0');
                NEXT_STATE <= s0;
            end if;
        when s2 =>
            if (i_start = '1') then
                if (i_mem_data = "00000000" and i_j = "00000000001") then 
                    o_mem_we <= '1';
                    o_mem_en <= '1';
                    o_mem_add <= std_logic_vector(UNSIGNED(i_add) + UNSIGNED(i_j));
                    o_ec <= '0';
                    o_done <= '0';
                    o_mem_data <= (others => '0');
                    NEXT_STATE <= s3;
                elsif (UNSIGNED(i_mem_data) /= 0) then
                    o_mem_we <= '1';
                    o_mem_en <= '1';
                    o_ec <= '0';
                    o_mem_add <= std_logic_vector(UNSIGNED(i_add) + UNSIGNED(i_j));
                    o_mem_data <= "00011111";
                    o_done <= '0';
                    NEXT_STATE <= s3;
                elsif (i_mem_data = "00000000") then
                    o_mem_en <= '1';
                    o_mem_we <= '0';
                    o_ec <= '0';
                    o_mem_add <= std_logic_vector(UNSIGNED(i_add) + UNSIGNED(i_j) - 2);
                    o_done <= '0';
                    o_mem_data <= (others => '0');
                    NEXT_STATE <= s4;
                else 
                    o_mem_we <= '0';
                    o_mem_en <= '0';
                    o_ec <= '0';
                    o_done <= '0';
                    o_mem_add <= (others => '0');
                    o_mem_data <= (others => '0');
                    NEXT_STATE <= s0;
                end if;
            else 
                o_mem_we <= '0';
                o_mem_en <= '0';
                o_ec <= '0';
                o_done <= '0';
                o_mem_add <= (others => '0');
                o_mem_data <= (others => '0');
                NEXT_STATE <= s0;
            end if;
        when s3 =>
            if (i_start = '1') then
                o_mem_en <= '0';
                o_mem_we <= '0';
                o_ec <= '1';
                o_done <= '0';
                o_mem_add <= (others => '0');
                o_mem_data <= (others => '0');
                NEXT_STATE <= s1;
            else 
                o_mem_we <= '0';
                o_mem_en <= '0';
                o_ec <= '0';
                o_done <= '0';
                o_mem_add <= (others => '0');
                o_mem_data <= (others => '0');
                NEXT_STATE <= s0;
            end if;
        when s4 =>
            if (i_start = '1' and i_mem_data = "00000000") then
                o_mem_en <= '0';
                o_mem_we <= '0';
                o_ec <= '0';
                o_done <= '0';
                o_mem_add <= (others => '0');
                o_mem_data <= (others => '0');
                NEXT_STATE <= s3;
            elsif (i_start = '1' and UNSIGNED(i_mem_data) /= 0) then
                o_mem_en <= '1';
                o_mem_we <= '1';
                o_ec <= '0';
                o_mem_data <= std_logic_vector(UNSIGNED(i_mem_data) - 1);
                o_mem_add <= std_logic_vector(UNSIGNED(i_add) + UNSIGNED(i_j));
                o_done <= '0';
                NEXT_STATE <= s5;
            else 
                o_mem_we <= '0';
                o_mem_en <= '0';
                o_ec <= '0';
                o_done <= '0';
                o_mem_add <= (others => '0');
                o_mem_data <= (others => '0');
                NEXT_STATE <= s0;
            end if;
        when s5 =>
            if (i_start = '1') then
                o_mem_we <= '0';
                o_mem_en <= '1';
                o_ec <= '0';
                o_mem_add <= std_logic_vector(UNSIGNED(i_add) + UNSIGNED(i_j) - 3);
                o_done <= '0';
                o_mem_data <= (others => '0');
                NEXT_STATE <= s6;
            else 
                o_mem_we <= '0';
                o_mem_en <= '0';
                o_ec <= '0';
                o_done <= '0';
                o_mem_add <= (others => '0');
                o_mem_data <= (others => '0');
                NEXT_STATE <= s0;
            end if;
        when s6 =>
            if (i_start = '1') then
                o_mem_add <= std_logic_vector(UNSIGNED(i_add) + UNSIGNED(i_j) - 1);
                o_mem_data <= i_mem_data;
                o_mem_we <= '1';
                o_mem_en <= '1';
                o_ec <= '1';
                o_done <= '0';
                NEXT_STATE <= s1;
            else 
                o_mem_we <= '0';
                o_mem_en <= '0';
                o_ec <= '0';
                o_done <= '0';
                o_mem_add <= (others => '0');
                o_mem_data <= (others => '0');
                NEXT_STATE <= s0;            
            end if;
        when s7 =>
            if (i_start = '0') then
                o_mem_en <= '0';
                o_mem_we <= '0';
                o_ec <= '0';
                o_done <= '1';
                o_mem_add <= (others => '0');
                o_mem_data <= (others => '0');
                NEXT_STATE <= s8;
            else
                o_mem_we <= '0';
                o_mem_en <= '0';
                o_ec <= '0';
                o_done <= '1';
                o_mem_add <= (others => '0');
                o_mem_data <= (others => '0');
                NEXT_STATE <= s0;
            end if;
        when s8 =>
            if (i_start = '0') then
                o_mem_en <= '0';
                o_mem_we <= '0';
                o_ec <= '0';
                o_done <= '0';
                o_mem_add <= (others => '0');
                o_mem_data <= (others => '0');
                NEXT_STATE <= s9;
            else
                o_mem_we <= '0';
                o_mem_en <= '0';
                o_ec <= '0';
                o_done <= '0';
                o_mem_add <= (others => '0');
                o_mem_data <= (others => '0');
                NEXT_STATE <= s0;
            end if;
        when s9 =>
            if (i_start = '1') then
                o_mem_en <= '0';
                o_mem_we <= '0';
                o_ec <= '0';
                o_done <= '0';
                o_mem_add <= (others => '0');
                o_mem_data <= (others => '0');
                NEXT_STATE <= s1;
            else
                o_mem_we <= '0';
                o_mem_en <= '0';
                o_ec <= '0';
                o_done <= '0';
                o_mem_add <= (others => '0');
                o_mem_data <= (others => '0');
                NEXT_STATE <= s0;
            end if;        
    end case;
end process;

end;