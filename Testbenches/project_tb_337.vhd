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

constant SCENARIO_LENGTH : integer := 508;
    type scenario_type is array (0 to SCENARIO_LENGTH*2-1) of integer;

signal scenario_input : scenario_type := (5,0,200,0,0,0,238,0,227,0,214,0,0,0,14,0,192,0,71,0,11,0,22,0,168,0,138,0,218,0,0,0,74,0,0,0,119,0,164,0,239,0,63,0,152,0,73,0,0,0,0,0,0,0,0,0,109,0,2,0,12,0,108,0,64,0,24,0,194,0,0,0,81,0,49,0,63,0,0,0,32,0,115,0,110,0,73,0,128,0,39,0,23,0,125,0,213,0,63,0,217,0,0,0,118,0,193,0,43,0,237,0,0,0,154,0,213,0,0,0,38,0,113,0,17,0,0,0,39,0,224,0,188,0,204,0,108,0,125,0,255,0,57,0,55,0,188,0,125,0,42,0,252,0,0,0,141,0,226,0,77,0,138,0,22,0,0,0,0,0,217,0,161,0,197,0,120,0,227,0,96,0,203,0,32,0,218,0,83,0,0,0,22,0,11,0,188,0,214,0,163,0,102,0,0,0,58,0,201,0,0,0,29,0,33,0,195,0,117,0,132,0,213,0,72,0,148,0,0,0,74,0,124,0,0,0,247,0,7,0,190,0,70,0,0,0,6,0,216,0,104,0,59,0,72,0,121,0,122,0,219,0,81,0,130,0,110,0,25,0,190,0,13,0,9,0,230,0,0,0,17,0,141,0,116,0,65,0,213,0,133,0,8,0,88,0,6,0,34,0,38,0,0,0,57,0,72,0,235,0,199,0,253,0,0,0,5,0,183,0,137,0,97,0,67,0,33,0,74,0,204,0,136,0,198,0,166,0,46,0,68,0,164,0,128,0,73,0,213,0,52,0,0,0,228,0,0,0,61,0,151,0,165,0,200,0,9,0,0,0,204,0,10,0,242,0,128,0,95,0,217,0,0,0,39,0,0,0,50,0,198,0,230,0,229,0,94,0,253,0,17,0,0,0,13,0,102,0,0,0,127,0,0,0,33,0,136,0,129,0,2,0,114,0,206,0,212,0,45,0,15,0,204,0,223,0,42,0,171,0,177,0,122,0,84,0,159,0,0,0,243,0,140,0,60,0,0,0,117,0,167,0,0,0,27,0,160,0,101,0,204,0,0,0,0,0,93,0,56,0,0,0,0,0,0,0,5,0,52,0,231,0,197,0,78,0,0,0,44,0,171,0,55,0,168,0,62,0,156,0,210,0,0,0,13,0,0,0,71,0,193,0,118,0,68,0,0,0,49,0,135,0,0,0,251,0,100,0,95,0,112,0,140,0,0,0,134,0,0,0,103,0,27,0,148,0,135,0,21,0,178,0,127,0,91,0,29,0,130,0,117,0,0,0,254,0,0,0,73,0,36,0,233,0,48,0,203,0,208,0,31,0,18,0,114,0,93,0,202,0,0,0,0,0,0,0,109,0,134,0,0,0,130,0,0,0,223,0,12,0,0,0,62,0,60,0,0,0,3,0,161,0,24,0,0,0,96,0,64,0,52,0,12,0,197,0,0,0,137,0,6,0,198,0,197,0,31,0,0,0,215,0,0,0,250,0,181,0,137,0,131,0,79,0,104,0,162,0,91,0,51,0,153,0,30,0,165,0,0,0,43,0,19,0,242,0,18,0,110,0,3,0,217,0,0,0,0,0,140,0,29,0,95,0,26,0,0,0,67,0,135,0,233,0,88,0,23,0,76,0,180,0,126,0,203,0,113,0,17,0,85,0,173,0,169,0,233,0,0,0,0,0,0,0,60,0,192,0,4,0,0,0,124,0,244,0,5,0,207,0,107,0,0,0,0,0,197,0,151,0,171,0,90,0,188,0,0,0,192,0,103,0,216,0,61,0,175,0,153,0,161,0,187,0,150,0,56,0,219,0,0,0,223,0,26,0,61,0,49,0,124,0,0,0,188,0,68,0,247,0,20,0,150,0,78,0,89,0,224,0,73,0,0,0,0,0,14,0,189,0,146,0,215,0,74,0,88,0,192,0,175,0,129,0,73,0,31,0,138,0,145,0,227,0,42,0,157,0,240,0,0,0,97,0,71,0,0,0,202,0,6,0,113,0,9,0,38,0,176,0,204,0,228,0,232,0,0,0,0,0,209,0,57,0,86,0,92,0,138,0,0,0,114,0,101,0,18,0,117,0,211,0,11,0,29,0,157,0,138,0,0,0,0,0,9,0,162,0,0,0,244,0,159,0,159,0,139,0,235,0,115,0,0,0,12,0,58,0,0,0,27,0,135,0,117,0,72,0,193,0,170,0,0,0,76,0,69,0,75,0,75,0,230,0,35,0,0,0,75,0,210,0,142,0,0,0,133,0,154,0,113,0,0,0,240,0);
signal scenario_full  : scenario_type := (5,31,200,31,200,30,238,31,227,31,214,31,214,30,14,31,192,31,71,31,11,31,22,31,168,31,138,31,218,31,218,30,74,31,74,30,119,31,164,31,239,31,63,31,152,31,73,31,73,30,73,29,73,28,73,27,109,31,2,31,12,31,108,31,64,31,24,31,194,31,194,30,81,31,49,31,63,31,63,30,32,31,115,31,110,31,73,31,128,31,39,31,23,31,125,31,213,31,63,31,217,31,217,30,118,31,193,31,43,31,237,31,237,30,154,31,213,31,213,30,38,31,113,31,17,31,17,30,39,31,224,31,188,31,204,31,108,31,125,31,255,31,57,31,55,31,188,31,125,31,42,31,252,31,252,30,141,31,226,31,77,31,138,31,22,31,22,30,22,29,217,31,161,31,197,31,120,31,227,31,96,31,203,31,32,31,218,31,83,31,83,30,22,31,11,31,188,31,214,31,163,31,102,31,102,30,58,31,201,31,201,30,29,31,33,31,195,31,117,31,132,31,213,31,72,31,148,31,148,30,74,31,124,31,124,30,247,31,7,31,190,31,70,31,70,30,6,31,216,31,104,31,59,31,72,31,121,31,122,31,219,31,81,31,130,31,110,31,25,31,190,31,13,31,9,31,230,31,230,30,17,31,141,31,116,31,65,31,213,31,133,31,8,31,88,31,6,31,34,31,38,31,38,30,57,31,72,31,235,31,199,31,253,31,253,30,5,31,183,31,137,31,97,31,67,31,33,31,74,31,204,31,136,31,198,31,166,31,46,31,68,31,164,31,128,31,73,31,213,31,52,31,52,30,228,31,228,30,61,31,151,31,165,31,200,31,9,31,9,30,204,31,10,31,242,31,128,31,95,31,217,31,217,30,39,31,39,30,50,31,198,31,230,31,229,31,94,31,253,31,17,31,17,30,13,31,102,31,102,30,127,31,127,30,33,31,136,31,129,31,2,31,114,31,206,31,212,31,45,31,15,31,204,31,223,31,42,31,171,31,177,31,122,31,84,31,159,31,159,30,243,31,140,31,60,31,60,30,117,31,167,31,167,30,27,31,160,31,101,31,204,31,204,30,204,29,93,31,56,31,56,30,56,29,56,28,5,31,52,31,231,31,197,31,78,31,78,30,44,31,171,31,55,31,168,31,62,31,156,31,210,31,210,30,13,31,13,30,71,31,193,31,118,31,68,31,68,30,49,31,135,31,135,30,251,31,100,31,95,31,112,31,140,31,140,30,134,31,134,30,103,31,27,31,148,31,135,31,21,31,178,31,127,31,91,31,29,31,130,31,117,31,117,30,254,31,254,30,73,31,36,31,233,31,48,31,203,31,208,31,31,31,18,31,114,31,93,31,202,31,202,30,202,29,202,28,109,31,134,31,134,30,130,31,130,30,223,31,12,31,12,30,62,31,60,31,60,30,3,31,161,31,24,31,24,30,96,31,64,31,52,31,12,31,197,31,197,30,137,31,6,31,198,31,197,31,31,31,31,30,215,31,215,30,250,31,181,31,137,31,131,31,79,31,104,31,162,31,91,31,51,31,153,31,30,31,165,31,165,30,43,31,19,31,242,31,18,31,110,31,3,31,217,31,217,30,217,29,140,31,29,31,95,31,26,31,26,30,67,31,135,31,233,31,88,31,23,31,76,31,180,31,126,31,203,31,113,31,17,31,85,31,173,31,169,31,233,31,233,30,233,29,233,28,60,31,192,31,4,31,4,30,124,31,244,31,5,31,207,31,107,31,107,30,107,29,197,31,151,31,171,31,90,31,188,31,188,30,192,31,103,31,216,31,61,31,175,31,153,31,161,31,187,31,150,31,56,31,219,31,219,30,223,31,26,31,61,31,49,31,124,31,124,30,188,31,68,31,247,31,20,31,150,31,78,31,89,31,224,31,73,31,73,30,73,29,14,31,189,31,146,31,215,31,74,31,88,31,192,31,175,31,129,31,73,31,31,31,138,31,145,31,227,31,42,31,157,31,240,31,240,30,97,31,71,31,71,30,202,31,6,31,113,31,9,31,38,31,176,31,204,31,228,31,232,31,232,30,232,29,209,31,57,31,86,31,92,31,138,31,138,30,114,31,101,31,18,31,117,31,211,31,11,31,29,31,157,31,138,31,138,30,138,29,9,31,162,31,162,30,244,31,159,31,159,31,139,31,235,31,115,31,115,30,12,31,58,31,58,30,27,31,135,31,117,31,72,31,193,31,170,31,170,30,76,31,69,31,75,31,75,31,230,31,35,31,35,30,75,31,210,31,142,31,142,30,133,31,154,31,113,31,113,30,240,31);

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
