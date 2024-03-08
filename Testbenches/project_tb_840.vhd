-- TB EXAMPLE PFRL 2023-2024

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use std.textio.all;

entity project_tb_840 is
end project_tb_840;

architecture project_tb_arch_840 of project_tb_840 is
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

constant SCENARIO_LENGTH : integer := 483;
    type scenario_type is array (0 to SCENARIO_LENGTH*2-1) of integer;

signal scenario_input : scenario_type := (9,0,46,0,173,0,161,0,14,0,102,0,124,0,229,0,77,0,82,0,0,0,40,0,194,0,160,0,53,0,114,0,153,0,37,0,190,0,137,0,232,0,246,0,169,0,69,0,226,0,176,0,231,0,21,0,83,0,127,0,0,0,133,0,0,0,215,0,0,0,0,0,77,0,0,0,84,0,90,0,0,0,210,0,110,0,42,0,97,0,109,0,250,0,73,0,0,0,73,0,42,0,0,0,99,0,216,0,159,0,213,0,154,0,170,0,45,0,20,0,46,0,4,0,0,0,161,0,116,0,137,0,69,0,13,0,125,0,127,0,68,0,55,0,0,0,51,0,55,0,208,0,210,0,168,0,96,0,222,0,0,0,20,0,197,0,0,0,253,0,181,0,80,0,34,0,219,0,162,0,29,0,0,0,218,0,5,0,0,0,0,0,157,0,7,0,177,0,176,0,0,0,56,0,228,0,159,0,223,0,53,0,215,0,0,0,116,0,44,0,172,0,143,0,110,0,32,0,49,0,3,0,14,0,26,0,0,0,209,0,127,0,215,0,197,0,121,0,25,0,70,0,207,0,128,0,187,0,63,0,208,0,134,0,238,0,253,0,199,0,48,0,86,0,80,0,169,0,234,0,62,0,0,0,245,0,254,0,0,0,103,0,10,0,0,0,174,0,215,0,142,0,54,0,16,0,48,0,249,0,0,0,101,0,202,0,26,0,186,0,188,0,174,0,215,0,221,0,124,0,36,0,60,0,164,0,123,0,0,0,110,0,0,0,48,0,0,0,77,0,0,0,179,0,114,0,123,0,68,0,30,0,85,0,135,0,118,0,15,0,66,0,88,0,73,0,63,0,141,0,61,0,21,0,99,0,208,0,233,0,141,0,204,0,0,0,119,0,43,0,254,0,102,0,96,0,176,0,189,0,108,0,152,0,38,0,121,0,251,0,52,0,193,0,134,0,0,0,29,0,160,0,210,0,62,0,159,0,161,0,47,0,24,0,102,0,192,0,214,0,0,0,217,0,130,0,111,0,61,0,153,0,69,0,0,0,0,0,220,0,109,0,19,0,96,0,92,0,224,0,16,0,237,0,112,0,0,0,78,0,0,0,113,0,104,0,0,0,190,0,236,0,0,0,224,0,139,0,239,0,178,0,176,0,164,0,55,0,79,0,0,0,0,0,12,0,0,0,243,0,237,0,0,0,60,0,147,0,232,0,116,0,217,0,143,0,92,0,193,0,163,0,14,0,34,0,48,0,140,0,88,0,6,0,0,0,143,0,0,0,171,0,55,0,123,0,89,0,185,0,0,0,149,0,165,0,199,0,57,0,131,0,131,0,26,0,7,0,169,0,43,0,0,0,189,0,124,0,243,0,15,0,209,0,34,0,77,0,241,0,0,0,170,0,182,0,0,0,155,0,0,0,121,0,0,0,6,0,166,0,228,0,39,0,0,0,0,0,146,0,36,0,0,0,134,0,0,0,0,0,133,0,0,0,67,0,127,0,64,0,0,0,26,0,0,0,235,0,73,0,1,0,253,0,229,0,41,0,121,0,0,0,0,0,133,0,0,0,191,0,122,0,0,0,0,0,24,0,145,0,98,0,125,0,42,0,241,0,233,0,210,0,39,0,65,0,213,0,212,0,14,0,54,0,16,0,142,0,29,0,63,0,39,0,160,0,41,0,0,0,0,0,190,0,0,0,161,0,140,0,120,0,119,0,147,0,182,0,109,0,29,0,186,0,31,0,192,0,108,0,149,0,163,0,0,0,117,0,0,0,0,0,23,0,82,0,105,0,139,0,158,0,149,0,0,0,62,0,132,0,113,0,24,0,199,0,38,0,206,0,167,0,213,0,103,0,110,0,170,0,224,0,224,0,193,0,0,0,204,0,59,0,96,0,230,0,0,0,59,0,154,0,64,0,15,0,185,0,135,0,51,0,137,0,0,0,136,0,193,0,60,0,15,0,108,0,218,0,0,0,48,0,94,0,8,0,177,0,19,0,34,0,0,0,12,0,190,0,108,0,0,0,18,0,125,0,67,0,125,0,121,0,0,0,125,0,0,0,241,0,28,0,0,0,139,0,7,0,81,0,4,0,29,0,133,0,50,0,0,0,51,0,110,0,141,0,55,0,80,0,228,0,0,0,0,0,121,0,87,0,14,0,0,0,0,0);
signal scenario_full  : scenario_type := (9,31,46,31,173,31,161,31,14,31,102,31,124,31,229,31,77,31,82,31,82,30,40,31,194,31,160,31,53,31,114,31,153,31,37,31,190,31,137,31,232,31,246,31,169,31,69,31,226,31,176,31,231,31,21,31,83,31,127,31,127,30,133,31,133,30,215,31,215,30,215,29,77,31,77,30,84,31,90,31,90,30,210,31,110,31,42,31,97,31,109,31,250,31,73,31,73,30,73,31,42,31,42,30,99,31,216,31,159,31,213,31,154,31,170,31,45,31,20,31,46,31,4,31,4,30,161,31,116,31,137,31,69,31,13,31,125,31,127,31,68,31,55,31,55,30,51,31,55,31,208,31,210,31,168,31,96,31,222,31,222,30,20,31,197,31,197,30,253,31,181,31,80,31,34,31,219,31,162,31,29,31,29,30,218,31,5,31,5,30,5,29,157,31,7,31,177,31,176,31,176,30,56,31,228,31,159,31,223,31,53,31,215,31,215,30,116,31,44,31,172,31,143,31,110,31,32,31,49,31,3,31,14,31,26,31,26,30,209,31,127,31,215,31,197,31,121,31,25,31,70,31,207,31,128,31,187,31,63,31,208,31,134,31,238,31,253,31,199,31,48,31,86,31,80,31,169,31,234,31,62,31,62,30,245,31,254,31,254,30,103,31,10,31,10,30,174,31,215,31,142,31,54,31,16,31,48,31,249,31,249,30,101,31,202,31,26,31,186,31,188,31,174,31,215,31,221,31,124,31,36,31,60,31,164,31,123,31,123,30,110,31,110,30,48,31,48,30,77,31,77,30,179,31,114,31,123,31,68,31,30,31,85,31,135,31,118,31,15,31,66,31,88,31,73,31,63,31,141,31,61,31,21,31,99,31,208,31,233,31,141,31,204,31,204,30,119,31,43,31,254,31,102,31,96,31,176,31,189,31,108,31,152,31,38,31,121,31,251,31,52,31,193,31,134,31,134,30,29,31,160,31,210,31,62,31,159,31,161,31,47,31,24,31,102,31,192,31,214,31,214,30,217,31,130,31,111,31,61,31,153,31,69,31,69,30,69,29,220,31,109,31,19,31,96,31,92,31,224,31,16,31,237,31,112,31,112,30,78,31,78,30,113,31,104,31,104,30,190,31,236,31,236,30,224,31,139,31,239,31,178,31,176,31,164,31,55,31,79,31,79,30,79,29,12,31,12,30,243,31,237,31,237,30,60,31,147,31,232,31,116,31,217,31,143,31,92,31,193,31,163,31,14,31,34,31,48,31,140,31,88,31,6,31,6,30,143,31,143,30,171,31,55,31,123,31,89,31,185,31,185,30,149,31,165,31,199,31,57,31,131,31,131,31,26,31,7,31,169,31,43,31,43,30,189,31,124,31,243,31,15,31,209,31,34,31,77,31,241,31,241,30,170,31,182,31,182,30,155,31,155,30,121,31,121,30,6,31,166,31,228,31,39,31,39,30,39,29,146,31,36,31,36,30,134,31,134,30,134,29,133,31,133,30,67,31,127,31,64,31,64,30,26,31,26,30,235,31,73,31,1,31,253,31,229,31,41,31,121,31,121,30,121,29,133,31,133,30,191,31,122,31,122,30,122,29,24,31,145,31,98,31,125,31,42,31,241,31,233,31,210,31,39,31,65,31,213,31,212,31,14,31,54,31,16,31,142,31,29,31,63,31,39,31,160,31,41,31,41,30,41,29,190,31,190,30,161,31,140,31,120,31,119,31,147,31,182,31,109,31,29,31,186,31,31,31,192,31,108,31,149,31,163,31,163,30,117,31,117,30,117,29,23,31,82,31,105,31,139,31,158,31,149,31,149,30,62,31,132,31,113,31,24,31,199,31,38,31,206,31,167,31,213,31,103,31,110,31,170,31,224,31,224,31,193,31,193,30,204,31,59,31,96,31,230,31,230,30,59,31,154,31,64,31,15,31,185,31,135,31,51,31,137,31,137,30,136,31,193,31,60,31,15,31,108,31,218,31,218,30,48,31,94,31,8,31,177,31,19,31,34,31,34,30,12,31,190,31,108,31,108,30,18,31,125,31,67,31,125,31,121,31,121,30,125,31,125,30,241,31,28,31,28,30,139,31,7,31,81,31,4,31,29,31,133,31,50,31,50,30,51,31,110,31,141,31,55,31,80,31,228,31,228,30,228,29,121,31,87,31,14,31,14,30,14,29);

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
