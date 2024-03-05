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

constant SCENARIO_LENGTH : integer := 543;
    type scenario_type is array (0 to SCENARIO_LENGTH*2-1) of integer;

signal scenario_input : scenario_type := (66,0,88,0,41,0,140,0,8,0,52,0,0,0,0,0,210,0,166,0,248,0,175,0,4,0,232,0,0,0,172,0,226,0,142,0,194,0,105,0,94,0,80,0,0,0,122,0,108,0,202,0,70,0,0,0,70,0,0,0,69,0,0,0,128,0,216,0,132,0,0,0,147,0,244,0,97,0,9,0,76,0,51,0,114,0,88,0,9,0,184,0,253,0,168,0,24,0,30,0,253,0,0,0,128,0,249,0,53,0,108,0,91,0,148,0,110,0,91,0,104,0,99,0,106,0,170,0,15,0,177,0,64,0,64,0,131,0,218,0,0,0,201,0,7,0,221,0,136,0,1,0,65,0,183,0,175,0,0,0,46,0,195,0,0,0,139,0,133,0,178,0,100,0,179,0,130,0,141,0,60,0,103,0,125,0,123,0,219,0,233,0,27,0,98,0,186,0,127,0,88,0,185,0,176,0,0,0,59,0,47,0,0,0,109,0,160,0,7,0,0,0,41,0,34,0,0,0,2,0,160,0,0,0,55,0,67,0,75,0,0,0,140,0,47,0,84,0,0,0,187,0,0,0,248,0,110,0,0,0,0,0,183,0,165,0,0,0,52,0,141,0,204,0,70,0,0,0,0,0,57,0,87,0,106,0,15,0,9,0,94,0,53,0,0,0,68,0,99,0,0,0,0,0,0,0,250,0,166,0,0,0,220,0,38,0,42,0,230,0,189,0,46,0,124,0,0,0,39,0,88,0,0,0,51,0,49,0,239,0,88,0,197,0,224,0,132,0,118,0,101,0,132,0,160,0,115,0,208,0,57,0,192,0,76,0,30,0,0,0,0,0,159,0,0,0,18,0,222,0,98,0,0,0,0,0,208,0,121,0,136,0,208,0,45,0,132,0,161,0,211,0,34,0,244,0,231,0,32,0,8,0,137,0,17,0,0,0,0,0,0,0,158,0,0,0,50,0,70,0,147,0,87,0,104,0,0,0,25,0,197,0,0,0,0,0,0,0,32,0,119,0,14,0,119,0,122,0,39,0,0,0,222,0,0,0,81,0,153,0,156,0,87,0,223,0,159,0,111,0,13,0,64,0,171,0,208,0,0,0,234,0,219,0,205,0,68,0,135,0,134,0,130,0,5,0,47,0,192,0,78,0,1,0,32,0,0,0,106,0,253,0,102,0,195,0,144,0,214,0,140,0,44,0,106,0,200,0,135,0,34,0,41,0,215,0,15,0,69,0,79,0,40,0,239,0,69,0,0,0,254,0,0,0,143,0,243,0,164,0,190,0,189,0,0,0,0,0,209,0,212,0,140,0,83,0,0,0,187,0,0,0,53,0,95,0,0,0,29,0,179,0,140,0,33,0,90,0,0,0,22,0,96,0,56,0,0,0,0,0,145,0,0,0,224,0,0,0,0,0,183,0,194,0,128,0,163,0,138,0,86,0,0,0,222,0,119,0,225,0,90,0,199,0,44,0,0,0,75,0,1,0,0,0,208,0,95,0,74,0,72,0,72,0,105,0,87,0,224,0,0,0,41,0,153,0,171,0,206,0,170,0,186,0,160,0,128,0,0,0,193,0,224,0,6,0,192,0,146,0,234,0,0,0,0,0,80,0,232,0,62,0,152,0,17,0,132,0,15,0,30,0,71,0,160,0,114,0,20,0,172,0,107,0,192,0,109,0,205,0,63,0,103,0,49,0,251,0,0,0,223,0,46,0,145,0,0,0,12,0,171,0,119,0,181,0,111,0,91,0,140,0,216,0,0,0,124,0,159,0,0,0,0,0,0,0,174,0,123,0,129,0,222,0,25,0,0,0,233,0,241,0,233,0,245,0,100,0,0,0,110,0,0,0,0,0,168,0,229,0,157,0,0,0,0,0,201,0,0,0,0,0,83,0,5,0,237,0,185,0,23,0,194,0,169,0,143,0,244,0,166,0,174,0,86,0,136,0,0,0,91,0,18,0,119,0,0,0,62,0,0,0,225,0,242,0,0,0,31,0,79,0,0,0,189,0,135,0,237,0,4,0,169,0,0,0,0,0,176,0,170,0,107,0,231,0,72,0,124,0,208,0,141,0,0,0,59,0,14,0,0,0,0,0,35,0,0,0,8,0,0,0,0,0,77,0,38,0,146,0,22,0,208,0,0,0,0,0,0,0,236,0,83,0,197,0,0,0,70,0,29,0,0,0,8,0,232,0,59,0,69,0,209,0,44,0,198,0,12,0,41,0,119,0,0,0,0,0,244,0,5,0,175,0,227,0,0,0,69,0,189,0,170,0,185,0,163,0,242,0,159,0,53,0,159,0,223,0,207,0,121,0,154,0,206,0,17,0,235,0,89,0,37,0,118,0,242,0,0,0,0,0,147,0,107,0,65,0,108,0,158,0,0,0,126,0,181,0,8,0,124,0,97,0,162,0,251,0,45,0,170,0,19,0,208,0);
signal scenario_full  : scenario_type := (66,31,88,31,41,31,140,31,8,31,52,31,52,30,52,29,210,31,166,31,248,31,175,31,4,31,232,31,232,30,172,31,226,31,142,31,194,31,105,31,94,31,80,31,80,30,122,31,108,31,202,31,70,31,70,30,70,31,70,30,69,31,69,30,128,31,216,31,132,31,132,30,147,31,244,31,97,31,9,31,76,31,51,31,114,31,88,31,9,31,184,31,253,31,168,31,24,31,30,31,253,31,253,30,128,31,249,31,53,31,108,31,91,31,148,31,110,31,91,31,104,31,99,31,106,31,170,31,15,31,177,31,64,31,64,31,131,31,218,31,218,30,201,31,7,31,221,31,136,31,1,31,65,31,183,31,175,31,175,30,46,31,195,31,195,30,139,31,133,31,178,31,100,31,179,31,130,31,141,31,60,31,103,31,125,31,123,31,219,31,233,31,27,31,98,31,186,31,127,31,88,31,185,31,176,31,176,30,59,31,47,31,47,30,109,31,160,31,7,31,7,30,41,31,34,31,34,30,2,31,160,31,160,30,55,31,67,31,75,31,75,30,140,31,47,31,84,31,84,30,187,31,187,30,248,31,110,31,110,30,110,29,183,31,165,31,165,30,52,31,141,31,204,31,70,31,70,30,70,29,57,31,87,31,106,31,15,31,9,31,94,31,53,31,53,30,68,31,99,31,99,30,99,29,99,28,250,31,166,31,166,30,220,31,38,31,42,31,230,31,189,31,46,31,124,31,124,30,39,31,88,31,88,30,51,31,49,31,239,31,88,31,197,31,224,31,132,31,118,31,101,31,132,31,160,31,115,31,208,31,57,31,192,31,76,31,30,31,30,30,30,29,159,31,159,30,18,31,222,31,98,31,98,30,98,29,208,31,121,31,136,31,208,31,45,31,132,31,161,31,211,31,34,31,244,31,231,31,32,31,8,31,137,31,17,31,17,30,17,29,17,28,158,31,158,30,50,31,70,31,147,31,87,31,104,31,104,30,25,31,197,31,197,30,197,29,197,28,32,31,119,31,14,31,119,31,122,31,39,31,39,30,222,31,222,30,81,31,153,31,156,31,87,31,223,31,159,31,111,31,13,31,64,31,171,31,208,31,208,30,234,31,219,31,205,31,68,31,135,31,134,31,130,31,5,31,47,31,192,31,78,31,1,31,32,31,32,30,106,31,253,31,102,31,195,31,144,31,214,31,140,31,44,31,106,31,200,31,135,31,34,31,41,31,215,31,15,31,69,31,79,31,40,31,239,31,69,31,69,30,254,31,254,30,143,31,243,31,164,31,190,31,189,31,189,30,189,29,209,31,212,31,140,31,83,31,83,30,187,31,187,30,53,31,95,31,95,30,29,31,179,31,140,31,33,31,90,31,90,30,22,31,96,31,56,31,56,30,56,29,145,31,145,30,224,31,224,30,224,29,183,31,194,31,128,31,163,31,138,31,86,31,86,30,222,31,119,31,225,31,90,31,199,31,44,31,44,30,75,31,1,31,1,30,208,31,95,31,74,31,72,31,72,31,105,31,87,31,224,31,224,30,41,31,153,31,171,31,206,31,170,31,186,31,160,31,128,31,128,30,193,31,224,31,6,31,192,31,146,31,234,31,234,30,234,29,80,31,232,31,62,31,152,31,17,31,132,31,15,31,30,31,71,31,160,31,114,31,20,31,172,31,107,31,192,31,109,31,205,31,63,31,103,31,49,31,251,31,251,30,223,31,46,31,145,31,145,30,12,31,171,31,119,31,181,31,111,31,91,31,140,31,216,31,216,30,124,31,159,31,159,30,159,29,159,28,174,31,123,31,129,31,222,31,25,31,25,30,233,31,241,31,233,31,245,31,100,31,100,30,110,31,110,30,110,29,168,31,229,31,157,31,157,30,157,29,201,31,201,30,201,29,83,31,5,31,237,31,185,31,23,31,194,31,169,31,143,31,244,31,166,31,174,31,86,31,136,31,136,30,91,31,18,31,119,31,119,30,62,31,62,30,225,31,242,31,242,30,31,31,79,31,79,30,189,31,135,31,237,31,4,31,169,31,169,30,169,29,176,31,170,31,107,31,231,31,72,31,124,31,208,31,141,31,141,30,59,31,14,31,14,30,14,29,35,31,35,30,8,31,8,30,8,29,77,31,38,31,146,31,22,31,208,31,208,30,208,29,208,28,236,31,83,31,197,31,197,30,70,31,29,31,29,30,8,31,232,31,59,31,69,31,209,31,44,31,198,31,12,31,41,31,119,31,119,30,119,29,244,31,5,31,175,31,227,31,227,30,69,31,189,31,170,31,185,31,163,31,242,31,159,31,53,31,159,31,223,31,207,31,121,31,154,31,206,31,17,31,235,31,89,31,37,31,118,31,242,31,242,30,242,29,147,31,107,31,65,31,108,31,158,31,158,30,126,31,181,31,8,31,124,31,97,31,162,31,251,31,45,31,170,31,19,31,208,31);

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
