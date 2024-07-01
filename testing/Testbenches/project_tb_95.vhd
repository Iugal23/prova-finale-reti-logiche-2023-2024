-- TB EXAMPLE PFRL 2023-2024

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use std.textio.all;

entity project_tb_95 is
end project_tb_95;

architecture project_tb_arch_95 of project_tb_95 is
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

constant SCENARIO_LENGTH : integer := 579;
    type scenario_type is array (0 to SCENARIO_LENGTH*2-1) of integer;

signal scenario_input : scenario_type := (47,0,48,0,191,0,169,0,229,0,0,0,65,0,112,0,170,0,0,0,146,0,128,0,158,0,39,0,3,0,83,0,129,0,135,0,8,0,202,0,0,0,206,0,80,0,43,0,98,0,0,0,0,0,234,0,41,0,185,0,0,0,176,0,217,0,226,0,249,0,139,0,42,0,125,0,148,0,115,0,157,0,132,0,232,0,104,0,0,0,72,0,240,0,231,0,0,0,170,0,60,0,0,0,4,0,71,0,215,0,7,0,0,0,145,0,0,0,48,0,114,0,40,0,154,0,2,0,23,0,72,0,168,0,18,0,248,0,213,0,13,0,231,0,0,0,223,0,0,0,191,0,0,0,172,0,42,0,181,0,138,0,253,0,207,0,43,0,133,0,0,0,240,0,113,0,196,0,213,0,100,0,26,0,27,0,115,0,131,0,183,0,89,0,71,0,0,0,149,0,44,0,118,0,235,0,0,0,0,0,191,0,135,0,164,0,214,0,171,0,0,0,142,0,253,0,194,0,106,0,54,0,246,0,0,0,156,0,33,0,38,0,0,0,236,0,204,0,0,0,171,0,0,0,51,0,168,0,122,0,0,0,51,0,219,0,33,0,184,0,117,0,0,0,11,0,0,0,20,0,0,0,16,0,248,0,4,0,0,0,203,0,203,0,0,0,233,0,206,0,7,0,116,0,70,0,25,0,14,0,0,0,0,0,46,0,0,0,222,0,28,0,64,0,234,0,146,0,148,0,116,0,83,0,143,0,63,0,0,0,94,0,88,0,38,0,75,0,190,0,203,0,198,0,0,0,123,0,92,0,251,0,20,0,165,0,98,0,0,0,73,0,181,0,2,0,224,0,121,0,0,0,143,0,75,0,165,0,30,0,0,0,0,0,68,0,137,0,223,0,0,0,119,0,159,0,22,0,163,0,133,0,71,0,177,0,141,0,0,0,246,0,192,0,24,0,154,0,44,0,50,0,0,0,15,0,237,0,0,0,108,0,0,0,0,0,160,0,0,0,0,0,222,0,156,0,155,0,0,0,0,0,122,0,159,0,57,0,113,0,0,0,228,0,68,0,255,0,11,0,12,0,187,0,77,0,218,0,109,0,167,0,27,0,116,0,197,0,15,0,116,0,0,0,0,0,162,0,129,0,0,0,110,0,3,0,151,0,0,0,5,0,74,0,234,0,193,0,50,0,119,0,0,0,91,0,3,0,227,0,8,0,0,0,0,0,98,0,40,0,150,0,116,0,254,0,0,0,181,0,86,0,255,0,63,0,88,0,103,0,124,0,62,0,211,0,74,0,101,0,45,0,113,0,201,0,0,0,216,0,0,0,0,0,3,0,206,0,47,0,76,0,0,0,165,0,188,0,96,0,91,0,39,0,9,0,0,0,56,0,241,0,145,0,0,0,184,0,18,0,0,0,35,0,166,0,0,0,112,0,148,0,119,0,252,0,248,0,0,0,243,0,224,0,242,0,150,0,231,0,54,0,128,0,248,0,49,0,63,0,0,0,155,0,125,0,0,0,130,0,135,0,117,0,110,0,202,0,42,0,15,0,189,0,253,0,206,0,20,0,135,0,70,0,250,0,126,0,250,0,166,0,249,0,205,0,229,0,0,0,223,0,112,0,0,0,212,0,105,0,252,0,9,0,0,0,0,0,169,0,0,0,0,0,85,0,72,0,196,0,38,0,0,0,0,0,185,0,78,0,38,0,63,0,61,0,162,0,129,0,254,0,194,0,22,0,187,0,129,0,0,0,17,0,94,0,98,0,117,0,136,0,189,0,49,0,0,0,0,0,101,0,211,0,175,0,244,0,167,0,0,0,0,0,0,0,162,0,28,0,0,0,1,0,127,0,168,0,112,0,0,0,67,0,142,0,35,0,4,0,0,0,202,0,42,0,0,0,156,0,0,0,223,0,54,0,33,0,101,0,0,0,194,0,16,0,60,0,0,0,0,0,170,0,97,0,23,0,110,0,229,0,48,0,0,0,204,0,43,0,0,0,145,0,70,0,90,0,164,0,19,0,38,0,36,0,38,0,153,0,132,0,22,0,0,0,22,0,0,0,94,0,242,0,0,0,0,0,251,0,104,0,0,0,214,0,207,0,29,0,216,0,234,0,132,0,50,0,167,0,20,0,92,0,248,0,157,0,244,0,219,0,0,0,134,0,156,0,253,0,212,0,85,0,105,0,0,0,248,0,82,0,0,0,33,0,27,0,161,0,122,0,154,0,176,0,19,0,207,0,85,0,167,0,37,0,141,0,233,0,69,0,0,0,174,0,231,0,92,0,88,0,185,0,76,0,246,0,188,0,3,0,214,0,0,0,134,0,216,0,187,0,32,0,122,0,141,0,132,0,11,0,126,0,188,0,23,0,95,0,0,0,134,0,131,0,0,0,181,0,102,0,0,0,132,0,157,0,166,0,141,0,202,0,153,0,102,0,45,0,160,0,0,0,130,0,174,0,37,0,237,0,207,0,214,0,164,0,95,0,71,0,38,0,10,0,0,0,110,0,100,0,102,0,0,0,82,0,0,0,0,0,9,0,208,0,104,0,157,0,0,0,0,0,0,0,47,0,2,0,35,0,0,0,134,0,244,0);
signal scenario_full  : scenario_type := (47,31,48,31,191,31,169,31,229,31,229,30,65,31,112,31,170,31,170,30,146,31,128,31,158,31,39,31,3,31,83,31,129,31,135,31,8,31,202,31,202,30,206,31,80,31,43,31,98,31,98,30,98,29,234,31,41,31,185,31,185,30,176,31,217,31,226,31,249,31,139,31,42,31,125,31,148,31,115,31,157,31,132,31,232,31,104,31,104,30,72,31,240,31,231,31,231,30,170,31,60,31,60,30,4,31,71,31,215,31,7,31,7,30,145,31,145,30,48,31,114,31,40,31,154,31,2,31,23,31,72,31,168,31,18,31,248,31,213,31,13,31,231,31,231,30,223,31,223,30,191,31,191,30,172,31,42,31,181,31,138,31,253,31,207,31,43,31,133,31,133,30,240,31,113,31,196,31,213,31,100,31,26,31,27,31,115,31,131,31,183,31,89,31,71,31,71,30,149,31,44,31,118,31,235,31,235,30,235,29,191,31,135,31,164,31,214,31,171,31,171,30,142,31,253,31,194,31,106,31,54,31,246,31,246,30,156,31,33,31,38,31,38,30,236,31,204,31,204,30,171,31,171,30,51,31,168,31,122,31,122,30,51,31,219,31,33,31,184,31,117,31,117,30,11,31,11,30,20,31,20,30,16,31,248,31,4,31,4,30,203,31,203,31,203,30,233,31,206,31,7,31,116,31,70,31,25,31,14,31,14,30,14,29,46,31,46,30,222,31,28,31,64,31,234,31,146,31,148,31,116,31,83,31,143,31,63,31,63,30,94,31,88,31,38,31,75,31,190,31,203,31,198,31,198,30,123,31,92,31,251,31,20,31,165,31,98,31,98,30,73,31,181,31,2,31,224,31,121,31,121,30,143,31,75,31,165,31,30,31,30,30,30,29,68,31,137,31,223,31,223,30,119,31,159,31,22,31,163,31,133,31,71,31,177,31,141,31,141,30,246,31,192,31,24,31,154,31,44,31,50,31,50,30,15,31,237,31,237,30,108,31,108,30,108,29,160,31,160,30,160,29,222,31,156,31,155,31,155,30,155,29,122,31,159,31,57,31,113,31,113,30,228,31,68,31,255,31,11,31,12,31,187,31,77,31,218,31,109,31,167,31,27,31,116,31,197,31,15,31,116,31,116,30,116,29,162,31,129,31,129,30,110,31,3,31,151,31,151,30,5,31,74,31,234,31,193,31,50,31,119,31,119,30,91,31,3,31,227,31,8,31,8,30,8,29,98,31,40,31,150,31,116,31,254,31,254,30,181,31,86,31,255,31,63,31,88,31,103,31,124,31,62,31,211,31,74,31,101,31,45,31,113,31,201,31,201,30,216,31,216,30,216,29,3,31,206,31,47,31,76,31,76,30,165,31,188,31,96,31,91,31,39,31,9,31,9,30,56,31,241,31,145,31,145,30,184,31,18,31,18,30,35,31,166,31,166,30,112,31,148,31,119,31,252,31,248,31,248,30,243,31,224,31,242,31,150,31,231,31,54,31,128,31,248,31,49,31,63,31,63,30,155,31,125,31,125,30,130,31,135,31,117,31,110,31,202,31,42,31,15,31,189,31,253,31,206,31,20,31,135,31,70,31,250,31,126,31,250,31,166,31,249,31,205,31,229,31,229,30,223,31,112,31,112,30,212,31,105,31,252,31,9,31,9,30,9,29,169,31,169,30,169,29,85,31,72,31,196,31,38,31,38,30,38,29,185,31,78,31,38,31,63,31,61,31,162,31,129,31,254,31,194,31,22,31,187,31,129,31,129,30,17,31,94,31,98,31,117,31,136,31,189,31,49,31,49,30,49,29,101,31,211,31,175,31,244,31,167,31,167,30,167,29,167,28,162,31,28,31,28,30,1,31,127,31,168,31,112,31,112,30,67,31,142,31,35,31,4,31,4,30,202,31,42,31,42,30,156,31,156,30,223,31,54,31,33,31,101,31,101,30,194,31,16,31,60,31,60,30,60,29,170,31,97,31,23,31,110,31,229,31,48,31,48,30,204,31,43,31,43,30,145,31,70,31,90,31,164,31,19,31,38,31,36,31,38,31,153,31,132,31,22,31,22,30,22,31,22,30,94,31,242,31,242,30,242,29,251,31,104,31,104,30,214,31,207,31,29,31,216,31,234,31,132,31,50,31,167,31,20,31,92,31,248,31,157,31,244,31,219,31,219,30,134,31,156,31,253,31,212,31,85,31,105,31,105,30,248,31,82,31,82,30,33,31,27,31,161,31,122,31,154,31,176,31,19,31,207,31,85,31,167,31,37,31,141,31,233,31,69,31,69,30,174,31,231,31,92,31,88,31,185,31,76,31,246,31,188,31,3,31,214,31,214,30,134,31,216,31,187,31,32,31,122,31,141,31,132,31,11,31,126,31,188,31,23,31,95,31,95,30,134,31,131,31,131,30,181,31,102,31,102,30,132,31,157,31,166,31,141,31,202,31,153,31,102,31,45,31,160,31,160,30,130,31,174,31,37,31,237,31,207,31,214,31,164,31,95,31,71,31,38,31,10,31,10,30,110,31,100,31,102,31,102,30,82,31,82,30,82,29,9,31,208,31,104,31,157,31,157,30,157,29,157,28,47,31,2,31,35,31,35,30,134,31,244,31);

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
