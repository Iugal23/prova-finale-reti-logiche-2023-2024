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

constant SCENARIO_LENGTH : integer := 610;
    type scenario_type is array (0 to SCENARIO_LENGTH*2-1) of integer;

signal scenario_input : scenario_type := (56,0,29,0,0,0,24,0,0,0,0,0,195,0,0,0,0,0,241,0,208,0,51,0,255,0,13,0,254,0,153,0,95,0,0,0,140,0,104,0,110,0,52,0,3,0,124,0,166,0,48,0,174,0,136,0,107,0,126,0,253,0,8,0,0,0,52,0,25,0,0,0,218,0,114,0,246,0,250,0,83,0,85,0,51,0,167,0,26,0,1,0,232,0,125,0,185,0,144,0,88,0,181,0,118,0,130,0,180,0,173,0,137,0,247,0,228,0,152,0,72,0,187,0,233,0,231,0,167,0,103,0,0,0,0,0,120,0,241,0,175,0,0,0,31,0,191,0,76,0,100,0,231,0,92,0,159,0,135,0,135,0,194,0,230,0,0,0,135,0,53,0,0,0,0,0,0,0,222,0,0,0,179,0,206,0,0,0,189,0,80,0,211,0,26,0,167,0,118,0,103,0,131,0,0,0,22,0,22,0,115,0,231,0,0,0,214,0,0,0,204,0,0,0,46,0,107,0,154,0,60,0,117,0,64,0,131,0,181,0,248,0,193,0,225,0,0,0,230,0,0,0,210,0,63,0,0,0,113,0,173,0,51,0,50,0,49,0,163,0,230,0,168,0,89,0,142,0,220,0,8,0,6,0,223,0,0,0,77,0,20,0,65,0,0,0,211,0,89,0,66,0,112,0,155,0,89,0,74,0,0,0,194,0,221,0,181,0,178,0,0,0,101,0,21,0,83,0,73,0,0,0,113,0,118,0,155,0,141,0,166,0,147,0,186,0,64,0,79,0,93,0,246,0,0,0,0,0,144,0,18,0,42,0,0,0,118,0,0,0,40,0,97,0,37,0,222,0,36,0,0,0,79,0,235,0,0,0,47,0,60,0,107,0,2,0,0,0,63,0,254,0,217,0,15,0,0,0,115,0,30,0,214,0,87,0,206,0,58,0,39,0,18,0,115,0,152,0,249,0,25,0,140,0,16,0,248,0,41,0,74,0,0,0,211,0,173,0,0,0,0,0,157,0,97,0,239,0,235,0,144,0,198,0,219,0,87,0,168,0,113,0,238,0,65,0,26,0,163,0,117,0,113,0,17,0,69,0,136,0,41,0,47,0,194,0,0,0,212,0,238,0,24,0,13,0,0,0,0,0,90,0,210,0,10,0,149,0,88,0,127,0,0,0,103,0,21,0,102,0,0,0,0,0,0,0,104,0,9,0,178,0,0,0,106,0,0,0,103,0,133,0,241,0,0,0,125,0,0,0,79,0,207,0,99,0,152,0,244,0,20,0,50,0,116,0,40,0,234,0,34,0,117,0,241,0,81,0,107,0,197,0,50,0,203,0,201,0,212,0,182,0,29,0,17,0,0,0,175,0,85,0,230,0,35,0,139,0,231,0,0,0,189,0,127,0,0,0,0,0,235,0,235,0,125,0,65,0,159,0,0,0,41,0,19,0,66,0,0,0,208,0,166,0,12,0,39,0,53,0,55,0,0,0,146,0,0,0,46,0,110,0,42,0,139,0,70,0,82,0,124,0,105,0,0,0,18,0,89,0,0,0,0,0,0,0,4,0,63,0,100,0,82,0,211,0,0,0,0,0,75,0,31,0,216,0,169,0,190,0,128,0,0,0,249,0,225,0,106,0,152,0,201,0,0,0,224,0,222,0,30,0,100,0,172,0,0,0,229,0,169,0,192,0,59,0,37,0,4,0,85,0,246,0,46,0,126,0,23,0,121,0,199,0,249,0,164,0,0,0,8,0,0,0,181,0,230,0,172,0,0,0,35,0,0,0,26,0,0,0,0,0,101,0,161,0,169,0,4,0,158,0,0,0,180,0,133,0,0,0,0,0,172,0,41,0,74,0,186,0,143,0,66,0,223,0,0,0,171,0,171,0,204,0,32,0,57,0,48,0,0,0,2,0,0,0,0,0,30,0,235,0,44,0,52,0,48,0,0,0,39,0,0,0,81,0,234,0,229,0,154,0,168,0,223,0,81,0,242,0,0,0,0,0,22,0,0,0,70,0,44,0,0,0,30,0,80,0,41,0,26,0,227,0,102,0,0,0,80,0,121,0,172,0,184,0,90,0,218,0,129,0,0,0,0,0,147,0,85,0,121,0,52,0,187,0,9,0,88,0,161,0,96,0,114,0,233,0,179,0,69,0,217,0,33,0,237,0,251,0,0,0,40,0,33,0,164,0,27,0,244,0,0,0,244,0,76,0,184,0,150,0,238,0,145,0,175,0,31,0,148,0,0,0,136,0,201,0,157,0,87,0,0,0,0,0,32,0,185,0,0,0,150,0,74,0,151,0,246,0,232,0,193,0,25,0,35,0,229,0,0,0,53,0,239,0,54,0,209,0,71,0,0,0,57,0,115,0,101,0,9,0,87,0,214,0,137,0,88,0,102,0,0,0,113,0,0,0,77,0,44,0,24,0,246,0,153,0,17,0,159,0,114,0,22,0,194,0,227,0,20,0,31,0,130,0,168,0,84,0,0,0,11,0,3,0,146,0,172,0,105,0,0,0,213,0,252,0,0,0,153,0,167,0,0,0,113,0,178,0,98,0,11,0,242,0,83,0,10,0,0,0,135,0,36,0,48,0,0,0,0,0,141,0,70,0,27,0,0,0,0,0,102,0,0,0,193,0,0,0,234,0,137,0,155,0,111,0,197,0,219,0,69,0,179,0,6,0,0,0,0,0,190,0,46,0,210,0,35,0,104,0,13,0,0,0,0,0,103,0);
signal scenario_full  : scenario_type := (56,31,29,31,29,30,24,31,24,30,24,29,195,31,195,30,195,29,241,31,208,31,51,31,255,31,13,31,254,31,153,31,95,31,95,30,140,31,104,31,110,31,52,31,3,31,124,31,166,31,48,31,174,31,136,31,107,31,126,31,253,31,8,31,8,30,52,31,25,31,25,30,218,31,114,31,246,31,250,31,83,31,85,31,51,31,167,31,26,31,1,31,232,31,125,31,185,31,144,31,88,31,181,31,118,31,130,31,180,31,173,31,137,31,247,31,228,31,152,31,72,31,187,31,233,31,231,31,167,31,103,31,103,30,103,29,120,31,241,31,175,31,175,30,31,31,191,31,76,31,100,31,231,31,92,31,159,31,135,31,135,31,194,31,230,31,230,30,135,31,53,31,53,30,53,29,53,28,222,31,222,30,179,31,206,31,206,30,189,31,80,31,211,31,26,31,167,31,118,31,103,31,131,31,131,30,22,31,22,31,115,31,231,31,231,30,214,31,214,30,204,31,204,30,46,31,107,31,154,31,60,31,117,31,64,31,131,31,181,31,248,31,193,31,225,31,225,30,230,31,230,30,210,31,63,31,63,30,113,31,173,31,51,31,50,31,49,31,163,31,230,31,168,31,89,31,142,31,220,31,8,31,6,31,223,31,223,30,77,31,20,31,65,31,65,30,211,31,89,31,66,31,112,31,155,31,89,31,74,31,74,30,194,31,221,31,181,31,178,31,178,30,101,31,21,31,83,31,73,31,73,30,113,31,118,31,155,31,141,31,166,31,147,31,186,31,64,31,79,31,93,31,246,31,246,30,246,29,144,31,18,31,42,31,42,30,118,31,118,30,40,31,97,31,37,31,222,31,36,31,36,30,79,31,235,31,235,30,47,31,60,31,107,31,2,31,2,30,63,31,254,31,217,31,15,31,15,30,115,31,30,31,214,31,87,31,206,31,58,31,39,31,18,31,115,31,152,31,249,31,25,31,140,31,16,31,248,31,41,31,74,31,74,30,211,31,173,31,173,30,173,29,157,31,97,31,239,31,235,31,144,31,198,31,219,31,87,31,168,31,113,31,238,31,65,31,26,31,163,31,117,31,113,31,17,31,69,31,136,31,41,31,47,31,194,31,194,30,212,31,238,31,24,31,13,31,13,30,13,29,90,31,210,31,10,31,149,31,88,31,127,31,127,30,103,31,21,31,102,31,102,30,102,29,102,28,104,31,9,31,178,31,178,30,106,31,106,30,103,31,133,31,241,31,241,30,125,31,125,30,79,31,207,31,99,31,152,31,244,31,20,31,50,31,116,31,40,31,234,31,34,31,117,31,241,31,81,31,107,31,197,31,50,31,203,31,201,31,212,31,182,31,29,31,17,31,17,30,175,31,85,31,230,31,35,31,139,31,231,31,231,30,189,31,127,31,127,30,127,29,235,31,235,31,125,31,65,31,159,31,159,30,41,31,19,31,66,31,66,30,208,31,166,31,12,31,39,31,53,31,55,31,55,30,146,31,146,30,46,31,110,31,42,31,139,31,70,31,82,31,124,31,105,31,105,30,18,31,89,31,89,30,89,29,89,28,4,31,63,31,100,31,82,31,211,31,211,30,211,29,75,31,31,31,216,31,169,31,190,31,128,31,128,30,249,31,225,31,106,31,152,31,201,31,201,30,224,31,222,31,30,31,100,31,172,31,172,30,229,31,169,31,192,31,59,31,37,31,4,31,85,31,246,31,46,31,126,31,23,31,121,31,199,31,249,31,164,31,164,30,8,31,8,30,181,31,230,31,172,31,172,30,35,31,35,30,26,31,26,30,26,29,101,31,161,31,169,31,4,31,158,31,158,30,180,31,133,31,133,30,133,29,172,31,41,31,74,31,186,31,143,31,66,31,223,31,223,30,171,31,171,31,204,31,32,31,57,31,48,31,48,30,2,31,2,30,2,29,30,31,235,31,44,31,52,31,48,31,48,30,39,31,39,30,81,31,234,31,229,31,154,31,168,31,223,31,81,31,242,31,242,30,242,29,22,31,22,30,70,31,44,31,44,30,30,31,80,31,41,31,26,31,227,31,102,31,102,30,80,31,121,31,172,31,184,31,90,31,218,31,129,31,129,30,129,29,147,31,85,31,121,31,52,31,187,31,9,31,88,31,161,31,96,31,114,31,233,31,179,31,69,31,217,31,33,31,237,31,251,31,251,30,40,31,33,31,164,31,27,31,244,31,244,30,244,31,76,31,184,31,150,31,238,31,145,31,175,31,31,31,148,31,148,30,136,31,201,31,157,31,87,31,87,30,87,29,32,31,185,31,185,30,150,31,74,31,151,31,246,31,232,31,193,31,25,31,35,31,229,31,229,30,53,31,239,31,54,31,209,31,71,31,71,30,57,31,115,31,101,31,9,31,87,31,214,31,137,31,88,31,102,31,102,30,113,31,113,30,77,31,44,31,24,31,246,31,153,31,17,31,159,31,114,31,22,31,194,31,227,31,20,31,31,31,130,31,168,31,84,31,84,30,11,31,3,31,146,31,172,31,105,31,105,30,213,31,252,31,252,30,153,31,167,31,167,30,113,31,178,31,98,31,11,31,242,31,83,31,10,31,10,30,135,31,36,31,48,31,48,30,48,29,141,31,70,31,27,31,27,30,27,29,102,31,102,30,193,31,193,30,234,31,137,31,155,31,111,31,197,31,219,31,69,31,179,31,6,31,6,30,6,29,190,31,46,31,210,31,35,31,104,31,13,31,13,30,13,29,103,31);

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
