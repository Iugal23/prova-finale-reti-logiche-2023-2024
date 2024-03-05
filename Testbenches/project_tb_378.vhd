-- TB EXAMPLE PFRL 2023-2024

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use std.textio.all;

entity project_tb is
end project_tb;

architecture project_tb_arch of project_tb is
    constant CLOCK_PERIOD : time := 20 ns;
    signal tb_clk : std_logic := '0';
    signal tb_rst, tb_start, tb_done : std_logic;
    signal tb_add : std_logic_vector(15 downto 0);
    signal tb_k   : std_logic_vector(9 downto 0);

    signal tb_o_mem_addr, exc_o_mem_addr, init_o_mem_addr : std_logic_vector(15 downto 0);
    signal tb_o_mem_data, exc_o_mem_data, init_o_mem_data : std_logic_vector(7 downto 0);
    signal tb_i_mem_data : std_logic_vector(7 downto 0);
    signal tb_o_mem_we, tb_o_mem_en, exc_o_mem_we, exc_o_mem_en, init_o_mem_we, init_o_mem_en : std_logic;

    type ram_type is array (65535 downto 0) of std_logic_vector(7 downto 0);
    signal RAM : ram_type := (OTHERS => "00000000");

constant SCENARIO_LENGTH : integer := 353;
    type scenario_type is array (0 to SCENARIO_LENGTH*2-1) of integer;

signal scenario_input : scenario_type := (76,0,139,0,64,0,0,0,68,0,57,0,40,0,224,0,54,0,94,0,234,0,214,0,0,0,220,0,135,0,138,0,0,0,0,0,135,0,0,0,0,0,6,0,80,0,60,0,188,0,77,0,84,0,144,0,0,0,0,0,159,0,139,0,131,0,174,0,118,0,8,0,125,0,237,0,155,0,0,0,0,0,185,0,93,0,239,0,179,0,22,0,200,0,0,0,0,0,248,0,208,0,158,0,4,0,163,0,108,0,0,0,83,0,88,0,0,0,87,0,220,0,79,0,67,0,0,0,245,0,135,0,0,0,147,0,254,0,0,0,0,0,166,0,6,0,118,0,183,0,202,0,82,0,0,0,207,0,0,0,187,0,92,0,166,0,253,0,44,0,0,0,244,0,190,0,221,0,42,0,44,0,7,0,237,0,150,0,0,0,56,0,166,0,47,0,43,0,0,0,146,0,77,0,31,0,214,0,250,0,19,0,8,0,0,0,27,0,15,0,65,0,23,0,0,0,78,0,79,0,209,0,179,0,156,0,172,0,254,0,55,0,7,0,23,0,153,0,143,0,158,0,8,0,52,0,145,0,36,0,246,0,206,0,197,0,118,0,173,0,6,0,55,0,5,0,45,0,0,0,91,0,0,0,38,0,21,0,215,0,25,0,248,0,28,0,0,0,187,0,252,0,39,0,220,0,101,0,220,0,111,0,109,0,137,0,140,0,235,0,0,0,137,0,0,0,133,0,143,0,236,0,38,0,0,0,26,0,167,0,0,0,100,0,228,0,225,0,114,0,48,0,226,0,141,0,97,0,9,0,230,0,202,0,78,0,127,0,105,0,0,0,0,0,204,0,13,0,0,0,204,0,215,0,38,0,201,0,67,0,0,0,204,0,187,0,182,0,0,0,0,0,46,0,72,0,88,0,171,0,101,0,0,0,0,0,54,0,224,0,110,0,0,0,183,0,0,0,0,0,242,0,73,0,111,0,254,0,84,0,21,0,39,0,90,0,90,0,0,0,0,0,0,0,66,0,169,0,216,0,10,0,0,0,0,0,220,0,159,0,66,0,149,0,128,0,172,0,209,0,80,0,0,0,32,0,68,0,221,0,249,0,236,0,66,0,34,0,0,0,0,0,93,0,106,0,142,0,87,0,0,0,211,0,222,0,84,0,32,0,0,0,0,0,55,0,143,0,183,0,0,0,157,0,0,0,194,0,128,0,0,0,248,0,31,0,173,0,124,0,0,0,238,0,6,0,154,0,91,0,105,0,205,0,224,0,179,0,237,0,129,0,228,0,220,0,73,0,0,0,182,0,237,0,165,0,90,0,66,0,142,0,5,0,38,0,225,0,188,0,0,0,48,0,0,0,175,0,0,0,31,0,9,0,0,0,0,0,143,0,105,0,203,0,0,0,0,0,203,0,91,0,97,0,0,0,216,0,0,0,222,0,0,0,204,0,42,0,60,0,44,0,177,0,123,0,203,0,209,0,86,0,185,0,81,0,90,0,223,0,0,0,0,0,165,0,122,0,0,0,19,0,2,0,217,0,123,0,45,0,46,0,170,0,97,0,227,0,74,0,64,0,241,0,14,0);
signal scenario_full  : scenario_type := (76,31,139,31,64,31,64,30,68,31,57,31,40,31,224,31,54,31,94,31,234,31,214,31,214,30,220,31,135,31,138,31,138,30,138,29,135,31,135,30,135,29,6,31,80,31,60,31,188,31,77,31,84,31,144,31,144,30,144,29,159,31,139,31,131,31,174,31,118,31,8,31,125,31,237,31,155,31,155,30,155,29,185,31,93,31,239,31,179,31,22,31,200,31,200,30,200,29,248,31,208,31,158,31,4,31,163,31,108,31,108,30,83,31,88,31,88,30,87,31,220,31,79,31,67,31,67,30,245,31,135,31,135,30,147,31,254,31,254,30,254,29,166,31,6,31,118,31,183,31,202,31,82,31,82,30,207,31,207,30,187,31,92,31,166,31,253,31,44,31,44,30,244,31,190,31,221,31,42,31,44,31,7,31,237,31,150,31,150,30,56,31,166,31,47,31,43,31,43,30,146,31,77,31,31,31,214,31,250,31,19,31,8,31,8,30,27,31,15,31,65,31,23,31,23,30,78,31,79,31,209,31,179,31,156,31,172,31,254,31,55,31,7,31,23,31,153,31,143,31,158,31,8,31,52,31,145,31,36,31,246,31,206,31,197,31,118,31,173,31,6,31,55,31,5,31,45,31,45,30,91,31,91,30,38,31,21,31,215,31,25,31,248,31,28,31,28,30,187,31,252,31,39,31,220,31,101,31,220,31,111,31,109,31,137,31,140,31,235,31,235,30,137,31,137,30,133,31,143,31,236,31,38,31,38,30,26,31,167,31,167,30,100,31,228,31,225,31,114,31,48,31,226,31,141,31,97,31,9,31,230,31,202,31,78,31,127,31,105,31,105,30,105,29,204,31,13,31,13,30,204,31,215,31,38,31,201,31,67,31,67,30,204,31,187,31,182,31,182,30,182,29,46,31,72,31,88,31,171,31,101,31,101,30,101,29,54,31,224,31,110,31,110,30,183,31,183,30,183,29,242,31,73,31,111,31,254,31,84,31,21,31,39,31,90,31,90,31,90,30,90,29,90,28,66,31,169,31,216,31,10,31,10,30,10,29,220,31,159,31,66,31,149,31,128,31,172,31,209,31,80,31,80,30,32,31,68,31,221,31,249,31,236,31,66,31,34,31,34,30,34,29,93,31,106,31,142,31,87,31,87,30,211,31,222,31,84,31,32,31,32,30,32,29,55,31,143,31,183,31,183,30,157,31,157,30,194,31,128,31,128,30,248,31,31,31,173,31,124,31,124,30,238,31,6,31,154,31,91,31,105,31,205,31,224,31,179,31,237,31,129,31,228,31,220,31,73,31,73,30,182,31,237,31,165,31,90,31,66,31,142,31,5,31,38,31,225,31,188,31,188,30,48,31,48,30,175,31,175,30,31,31,9,31,9,30,9,29,143,31,105,31,203,31,203,30,203,29,203,31,91,31,97,31,97,30,216,31,216,30,222,31,222,30,204,31,42,31,60,31,44,31,177,31,123,31,203,31,209,31,86,31,185,31,81,31,90,31,223,31,223,30,223,29,165,31,122,31,122,30,19,31,2,31,217,31,123,31,45,31,46,31,170,31,97,31,227,31,74,31,64,31,241,31,14,31);

    signal memory_control : std_logic := '0';
    
    constant SCENARIO_ADDRESS : integer := 1234;

    component project_reti_logiche is
        port (
                i_clk : in std_logic;
                i_rst : in std_logic;
                i_start : in std_logic;
                i_add : in std_logic_vector(15 downto 0);
                i_k   : in std_logic_vector(9 downto 0);
                
                o_done : out std_logic;
                
                o_mem_addr : out std_logic_vector(15 downto 0);
                i_mem_data : in  std_logic_vector(7 downto 0);
                o_mem_data : out std_logic_vector(7 downto 0);
                o_mem_we   : out std_logic;
                o_mem_en   : out std_logic
        );
    end component project_reti_logiche;

begin
    UUT : project_reti_logiche
    port map(
                i_clk   => tb_clk,
                i_rst   => tb_rst,
                i_start => tb_start,
                i_add   => tb_add,
                i_k     => tb_k,
                
                o_done => tb_done,
                
                o_mem_addr => exc_o_mem_addr,
                i_mem_data => tb_i_mem_data,
                o_mem_data => exc_o_mem_data,
                o_mem_we   => exc_o_mem_we,
                o_mem_en   => exc_o_mem_en
    );

    -- Clock generation
    tb_clk <= not tb_clk after CLOCK_PERIOD/2;

    -- Process related to the memory
    MEM : process (tb_clk)
    begin
        if tb_clk'event and tb_clk = '1' then
            if tb_o_mem_en = '1' then
                if tb_o_mem_we = '1' then
                    RAM(to_integer(unsigned(tb_o_mem_addr))) <= tb_o_mem_data after 1 ns;
                    tb_i_mem_data <= tb_o_mem_data after 1 ns;
                else
                    tb_i_mem_data <= RAM(to_integer(unsigned(tb_o_mem_addr))) after 1 ns;
                end if;
            end if;
        end if;
    end process;
    
    memory_signal_swapper : process(memory_control, init_o_mem_addr, init_o_mem_data,
                                    init_o_mem_en,  init_o_mem_we,   exc_o_mem_addr,
                                    exc_o_mem_data, exc_o_mem_en, exc_o_mem_we)
    begin
        -- This is necessary for the testbench to work: we swap the memory
        -- signals from the component to the testbench when needed.
    
        tb_o_mem_addr <= init_o_mem_addr;
        tb_o_mem_data <= init_o_mem_data;
        tb_o_mem_en   <= init_o_mem_en;
        tb_o_mem_we   <= init_o_mem_we;

        if memory_control = '1' then
            tb_o_mem_addr <= exc_o_mem_addr;
            tb_o_mem_data <= exc_o_mem_data;
            tb_o_mem_en   <= exc_o_mem_en;
            tb_o_mem_we   <= exc_o_mem_we;
        end if;
    end process;
    
    -- This process provides the correct scenario on the signal controlled by the TB
    create_scenario : process
    begin
        wait for 50 ns;

        -- Signal initialization and reset of the component
        tb_start <= '0';
        tb_add <= (others=>'0');
        tb_k   <= (others=>'0');
        tb_rst <= '1';
        
        -- Wait some time for the component to reset...
        wait for 50 ns;
        
        tb_rst <= '0';
        memory_control <= '0';  -- Memory controlled by the testbench
        
        wait until falling_edge(tb_clk); -- Skew the testbench transitions with respect to the clock

        -- Configure the memory        
        for i in 0 to SCENARIO_LENGTH*2-1 loop
            init_o_mem_addr<= std_logic_vector(to_unsigned(SCENARIO_ADDRESS+i, 16));
            init_o_mem_data<= std_logic_vector(to_unsigned(scenario_input(i),8));
            init_o_mem_en  <= '1';
            init_o_mem_we  <= '1';
            wait until rising_edge(tb_clk);   
        end loop;
        
        wait until falling_edge(tb_clk);

        memory_control <= '1';  -- Memory controlled by the component
        
        tb_add <= std_logic_vector(to_unsigned(SCENARIO_ADDRESS, 16));
        tb_k   <= std_logic_vector(to_unsigned(SCENARIO_LENGTH, 10));
        
        tb_start <= '1';

        while tb_done /= '1' loop                
            wait until rising_edge(tb_clk);
        end loop;

        wait for 5 ns;
        
        tb_start <= '0';
        
        wait;
        
    end process;

    -- Process without sensitivity list designed to test the actual component.
    test_routine : process
    begin

        wait until tb_rst = '1';
        wait for 25 ns;
        assert tb_done = '0' report "TEST FALLITO o_done !=0 during reset" severity failure;
        wait until tb_rst = '0';

        wait until falling_edge(tb_clk);
        assert tb_done = '0' report "TEST FALLITO o_done !=0 after reset before start" severity failure;
        
        wait until rising_edge(tb_start);

        while tb_done /= '1' loop                
            wait until rising_edge(tb_clk);
        end loop;

        assert tb_o_mem_en = '0' or tb_o_mem_we = '0' report "TEST FALLITO o_mem_en !=0 memory should not be written after done." severity failure;

        for i in 0 to SCENARIO_LENGTH*2-1 loop
            assert RAM(SCENARIO_ADDRESS+i) = std_logic_vector(to_unsigned(scenario_full(i),8)) report "TEST FALLITO @ OFFSET=" & integer'image(i) & " expected= " & integer'image(scenario_full(i)) & " actual=" & integer'image(to_integer(unsigned(RAM(i)))) severity failure;
        end loop;

        wait until falling_edge(tb_start);
        assert tb_done = '1' report "TEST FALLITO o_done !=0 after reset before start" severity failure;
        wait until falling_edge(tb_done);

        assert false report "Simulation Ended! TEST PASSATO (EXAMPLE)" severity failure;
    end process;

end architecture;
