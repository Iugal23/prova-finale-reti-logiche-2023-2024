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

constant SCENARIO_LENGTH : integer := 752;
    type scenario_type is array (0 to SCENARIO_LENGTH*2-1) of integer;

signal scenario_input : scenario_type := (0,0,0,0,165,0,115,0,0,0,98,0,0,0,0,0,139,0,148,0,57,0,45,0,0,0,60,0,76,0,36,0,170,0,85,0,40,0,147,0,145,0,192,0,0,0,0,0,68,0,23,0,0,0,74,0,0,0,244,0,111,0,119,0,0,0,127,0,85,0,71,0,254,0,241,0,181,0,9,0,0,0,247,0,99,0,85,0,107,0,205,0,245,0,178,0,14,0,228,0,86,0,205,0,48,0,167,0,104,0,90,0,130,0,136,0,17,0,0,0,4,0,108,0,79,0,161,0,41,0,32,0,99,0,57,0,121,0,130,0,217,0,251,0,130,0,253,0,155,0,230,0,0,0,140,0,231,0,0,0,100,0,129,0,16,0,194,0,0,0,250,0,108,0,0,0,0,0,241,0,0,0,246,0,84,0,181,0,223,0,125,0,179,0,160,0,208,0,90,0,61,0,130,0,82,0,146,0,250,0,195,0,0,0,94,0,115,0,156,0,56,0,31,0,49,0,209,0,116,0,255,0,220,0,206,0,190,0,51,0,71,0,0,0,87,0,0,0,56,0,134,0,129,0,196,0,95,0,221,0,181,0,232,0,180,0,210,0,171,0,0,0,0,0,163,0,185,0,65,0,205,0,196,0,71,0,214,0,234,0,246,0,0,0,210,0,0,0,51,0,214,0,45,0,48,0,137,0,215,0,230,0,0,0,135,0,70,0,69,0,0,0,57,0,9,0,0,0,252,0,41,0,12,0,174,0,38,0,210,0,71,0,112,0,103,0,100,0,216,0,0,0,252,0,38,0,253,0,94,0,87,0,216,0,0,0,72,0,139,0,142,0,118,0,10,0,192,0,0,0,223,0,219,0,233,0,169,0,84,0,22,0,219,0,224,0,0,0,98,0,167,0,212,0,218,0,119,0,156,0,251,0,210,0,133,0,42,0,138,0,97,0,93,0,0,0,205,0,171,0,221,0,7,0,214,0,175,0,127,0,217,0,33,0,155,0,253,0,243,0,0,0,0,0,0,0,137,0,40,0,76,0,194,0,230,0,211,0,89,0,11,0,53,0,140,0,126,0,155,0,216,0,68,0,41,0,0,0,43,0,0,0,93,0,234,0,153,0,23,0,170,0,0,0,214,0,112,0,82,0,81,0,3,0,116,0,0,0,33,0,192,0,129,0,38,0,242,0,89,0,107,0,245,0,233,0,143,0,0,0,103,0,226,0,11,0,205,0,237,0,166,0,248,0,44,0,114,0,239,0,192,0,5,0,247,0,144,0,0,0,44,0,3,0,2,0,207,0,244,0,0,0,79,0,185,0,116,0,129,0,116,0,0,0,74,0,56,0,140,0,212,0,127,0,0,0,119,0,120,0,0,0,0,0,0,0,159,0,75,0,161,0,144,0,141,0,119,0,227,0,0,0,89,0,18,0,169,0,153,0,230,0,234,0,195,0,129,0,56,0,0,0,153,0,113,0,0,0,220,0,212,0,135,0,31,0,131,0,73,0,17,0,124,0,220,0,12,0,177,0,91,0,0,0,97,0,10,0,0,0,228,0,14,0,0,0,0,0,59,0,12,0,121,0,254,0,238,0,1,0,112,0,52,0,142,0,228,0,0,0,0,0,0,0,130,0,86,0,227,0,58,0,164,0,51,0,217,0,0,0,236,0,135,0,136,0,150,0,125,0,0,0,132,0,233,0,0,0,135,0,204,0,27,0,0,0,0,0,123,0,131,0,242,0,0,0,0,0,11,0,0,0,149,0,97,0,30,0,211,0,40,0,215,0,185,0,30,0,46,0,0,0,234,0,183,0,217,0,124,0,122,0,210,0,69,0,115,0,68,0,0,0,14,0,118,0,0,0,0,0,73,0,140,0,16,0,166,0,43,0,74,0,0,0,0,0,85,0,113,0,208,0,0,0,0,0,116,0,216,0,212,0,0,0,159,0,37,0,0,0,214,0,39,0,0,0,155,0,0,0,51,0,44,0,18,0,175,0,214,0,68,0,142,0,11,0,0,0,63,0,41,0,53,0,9,0,224,0,128,0,188,0,91,0,0,0,23,0,0,0,0,0,226,0,27,0,241,0,35,0,0,0,35,0,251,0,0,0,220,0,213,0,147,0,191,0,0,0,72,0,70,0,200,0,12,0,5,0,0,0,0,0,0,0,239,0,205,0,155,0,39,0,120,0,234,0,45,0,32,0,0,0,103,0,255,0,254,0,0,0,0,0,55,0,84,0,71,0,0,0,184,0,0,0,0,0,0,0,94,0,0,0,0,0,122,0,135,0,136,0,236,0,247,0,86,0,244,0,209,0,148,0,0,0,0,0,169,0,31,0,43,0,53,0,130,0,204,0,32,0,130,0,187,0,229,0,233,0,77,0,155,0,122,0,233,0,50,0,226,0,182,0,209,0,156,0,0,0,67,0,48,0,63,0,0,0,0,0,253,0,0,0,0,0,109,0,0,0,0,0,0,0,77,0,63,0,0,0,45,0,162,0,170,0,0,0,139,0,187,0,101,0,176,0,63,0,234,0,93,0,247,0,178,0,33,0,194,0,130,0,0,0,229,0,67,0,154,0,4,0,138,0,199,0,0,0,243,0,222,0,64,0,51,0,23,0,125,0,35,0,128,0,7,0,252,0,131,0,240,0,119,0,8,0,202,0,216,0,102,0,19,0,64,0,209,0,0,0,108,0,0,0,96,0,40,0,44,0,0,0,81,0,52,0,0,0,22,0,121,0,194,0,158,0,79,0,0,0,21,0,166,0,211,0,247,0,206,0,169,0,113,0,38,0,93,0,3,0,47,0,37,0,239,0,36,0,95,0,0,0,0,0,12,0,0,0,21,0,29,0,180,0,175,0,138,0,169,0,0,0,0,0,38,0,203,0,179,0,62,0,85,0,240,0,62,0,53,0,86,0,0,0,49,0,206,0,120,0,194,0,122,0,122,0,55,0,11,0,87,0,198,0,148,0,39,0,65,0,12,0,131,0,34,0,153,0,21,0,80,0,215,0,30,0,8,0,68,0,215,0,0,0,0,0,0,0,0,0,89,0,227,0,214,0,44,0,188,0,0,0,0,0,184,0,106,0,252,0,74,0,14,0,60,0,174,0,0,0,0,0,101,0,79,0,191,0,0,0,44,0,84,0,213,0,19,0,77,0,176,0,243,0,54,0,0,0,0,0,0,0,52,0,89,0,134,0,164,0,0,0,9,0,11,0,0,0,142,0,94,0,170,0,0,0,10,0,50,0,0,0,141,0,205,0,145,0,63,0,0,0,18,0,78,0,143,0,7,0,85,0,0,0,169,0,239,0,250,0,36,0,103,0,71,0,84,0,156,0,27,0,139,0,0,0,233,0,157,0,0,0,0,0,181,0);
signal scenario_full  : scenario_type := (0,0,0,0,165,31,115,31,115,30,98,31,98,30,98,29,139,31,148,31,57,31,45,31,45,30,60,31,76,31,36,31,170,31,85,31,40,31,147,31,145,31,192,31,192,30,192,29,68,31,23,31,23,30,74,31,74,30,244,31,111,31,119,31,119,30,127,31,85,31,71,31,254,31,241,31,181,31,9,31,9,30,247,31,99,31,85,31,107,31,205,31,245,31,178,31,14,31,228,31,86,31,205,31,48,31,167,31,104,31,90,31,130,31,136,31,17,31,17,30,4,31,108,31,79,31,161,31,41,31,32,31,99,31,57,31,121,31,130,31,217,31,251,31,130,31,253,31,155,31,230,31,230,30,140,31,231,31,231,30,100,31,129,31,16,31,194,31,194,30,250,31,108,31,108,30,108,29,241,31,241,30,246,31,84,31,181,31,223,31,125,31,179,31,160,31,208,31,90,31,61,31,130,31,82,31,146,31,250,31,195,31,195,30,94,31,115,31,156,31,56,31,31,31,49,31,209,31,116,31,255,31,220,31,206,31,190,31,51,31,71,31,71,30,87,31,87,30,56,31,134,31,129,31,196,31,95,31,221,31,181,31,232,31,180,31,210,31,171,31,171,30,171,29,163,31,185,31,65,31,205,31,196,31,71,31,214,31,234,31,246,31,246,30,210,31,210,30,51,31,214,31,45,31,48,31,137,31,215,31,230,31,230,30,135,31,70,31,69,31,69,30,57,31,9,31,9,30,252,31,41,31,12,31,174,31,38,31,210,31,71,31,112,31,103,31,100,31,216,31,216,30,252,31,38,31,253,31,94,31,87,31,216,31,216,30,72,31,139,31,142,31,118,31,10,31,192,31,192,30,223,31,219,31,233,31,169,31,84,31,22,31,219,31,224,31,224,30,98,31,167,31,212,31,218,31,119,31,156,31,251,31,210,31,133,31,42,31,138,31,97,31,93,31,93,30,205,31,171,31,221,31,7,31,214,31,175,31,127,31,217,31,33,31,155,31,253,31,243,31,243,30,243,29,243,28,137,31,40,31,76,31,194,31,230,31,211,31,89,31,11,31,53,31,140,31,126,31,155,31,216,31,68,31,41,31,41,30,43,31,43,30,93,31,234,31,153,31,23,31,170,31,170,30,214,31,112,31,82,31,81,31,3,31,116,31,116,30,33,31,192,31,129,31,38,31,242,31,89,31,107,31,245,31,233,31,143,31,143,30,103,31,226,31,11,31,205,31,237,31,166,31,248,31,44,31,114,31,239,31,192,31,5,31,247,31,144,31,144,30,44,31,3,31,2,31,207,31,244,31,244,30,79,31,185,31,116,31,129,31,116,31,116,30,74,31,56,31,140,31,212,31,127,31,127,30,119,31,120,31,120,30,120,29,120,28,159,31,75,31,161,31,144,31,141,31,119,31,227,31,227,30,89,31,18,31,169,31,153,31,230,31,234,31,195,31,129,31,56,31,56,30,153,31,113,31,113,30,220,31,212,31,135,31,31,31,131,31,73,31,17,31,124,31,220,31,12,31,177,31,91,31,91,30,97,31,10,31,10,30,228,31,14,31,14,30,14,29,59,31,12,31,121,31,254,31,238,31,1,31,112,31,52,31,142,31,228,31,228,30,228,29,228,28,130,31,86,31,227,31,58,31,164,31,51,31,217,31,217,30,236,31,135,31,136,31,150,31,125,31,125,30,132,31,233,31,233,30,135,31,204,31,27,31,27,30,27,29,123,31,131,31,242,31,242,30,242,29,11,31,11,30,149,31,97,31,30,31,211,31,40,31,215,31,185,31,30,31,46,31,46,30,234,31,183,31,217,31,124,31,122,31,210,31,69,31,115,31,68,31,68,30,14,31,118,31,118,30,118,29,73,31,140,31,16,31,166,31,43,31,74,31,74,30,74,29,85,31,113,31,208,31,208,30,208,29,116,31,216,31,212,31,212,30,159,31,37,31,37,30,214,31,39,31,39,30,155,31,155,30,51,31,44,31,18,31,175,31,214,31,68,31,142,31,11,31,11,30,63,31,41,31,53,31,9,31,224,31,128,31,188,31,91,31,91,30,23,31,23,30,23,29,226,31,27,31,241,31,35,31,35,30,35,31,251,31,251,30,220,31,213,31,147,31,191,31,191,30,72,31,70,31,200,31,12,31,5,31,5,30,5,29,5,28,239,31,205,31,155,31,39,31,120,31,234,31,45,31,32,31,32,30,103,31,255,31,254,31,254,30,254,29,55,31,84,31,71,31,71,30,184,31,184,30,184,29,184,28,94,31,94,30,94,29,122,31,135,31,136,31,236,31,247,31,86,31,244,31,209,31,148,31,148,30,148,29,169,31,31,31,43,31,53,31,130,31,204,31,32,31,130,31,187,31,229,31,233,31,77,31,155,31,122,31,233,31,50,31,226,31,182,31,209,31,156,31,156,30,67,31,48,31,63,31,63,30,63,29,253,31,253,30,253,29,109,31,109,30,109,29,109,28,77,31,63,31,63,30,45,31,162,31,170,31,170,30,139,31,187,31,101,31,176,31,63,31,234,31,93,31,247,31,178,31,33,31,194,31,130,31,130,30,229,31,67,31,154,31,4,31,138,31,199,31,199,30,243,31,222,31,64,31,51,31,23,31,125,31,35,31,128,31,7,31,252,31,131,31,240,31,119,31,8,31,202,31,216,31,102,31,19,31,64,31,209,31,209,30,108,31,108,30,96,31,40,31,44,31,44,30,81,31,52,31,52,30,22,31,121,31,194,31,158,31,79,31,79,30,21,31,166,31,211,31,247,31,206,31,169,31,113,31,38,31,93,31,3,31,47,31,37,31,239,31,36,31,95,31,95,30,95,29,12,31,12,30,21,31,29,31,180,31,175,31,138,31,169,31,169,30,169,29,38,31,203,31,179,31,62,31,85,31,240,31,62,31,53,31,86,31,86,30,49,31,206,31,120,31,194,31,122,31,122,31,55,31,11,31,87,31,198,31,148,31,39,31,65,31,12,31,131,31,34,31,153,31,21,31,80,31,215,31,30,31,8,31,68,31,215,31,215,30,215,29,215,28,215,27,89,31,227,31,214,31,44,31,188,31,188,30,188,29,184,31,106,31,252,31,74,31,14,31,60,31,174,31,174,30,174,29,101,31,79,31,191,31,191,30,44,31,84,31,213,31,19,31,77,31,176,31,243,31,54,31,54,30,54,29,54,28,52,31,89,31,134,31,164,31,164,30,9,31,11,31,11,30,142,31,94,31,170,31,170,30,10,31,50,31,50,30,141,31,205,31,145,31,63,31,63,30,18,31,78,31,143,31,7,31,85,31,85,30,169,31,239,31,250,31,36,31,103,31,71,31,84,31,156,31,27,31,139,31,139,30,233,31,157,31,157,30,157,29,181,31);

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
