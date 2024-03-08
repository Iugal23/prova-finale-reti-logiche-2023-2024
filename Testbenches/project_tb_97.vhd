-- TB EXAMPLE PFRL 2023-2024

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use std.textio.all;

entity project_tb_97 is
end project_tb_97;

architecture project_tb_arch_97 of project_tb_97 is
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

constant SCENARIO_LENGTH : integer := 451;
    type scenario_type is array (0 to SCENARIO_LENGTH*2-1) of integer;

signal scenario_input : scenario_type := (122,0,196,0,203,0,97,0,213,0,216,0,65,0,118,0,225,0,46,0,215,0,38,0,184,0,0,0,38,0,63,0,195,0,216,0,240,0,110,0,211,0,0,0,192,0,74,0,108,0,36,0,0,0,9,0,180,0,0,0,69,0,220,0,245,0,9,0,15,0,177,0,168,0,65,0,17,0,73,0,0,0,234,0,206,0,132,0,177,0,21,0,65,0,182,0,12,0,222,0,79,0,226,0,74,0,158,0,27,0,181,0,53,0,184,0,109,0,0,0,5,0,0,0,54,0,51,0,73,0,56,0,0,0,253,0,38,0,112,0,0,0,142,0,142,0,103,0,195,0,164,0,231,0,88,0,75,0,76,0,0,0,0,0,96,0,210,0,7,0,0,0,0,0,165,0,4,0,144,0,125,0,0,0,0,0,253,0,54,0,248,0,105,0,0,0,42,0,79,0,211,0,114,0,131,0,23,0,215,0,0,0,105,0,76,0,0,0,23,0,62,0,218,0,66,0,196,0,0,0,81,0,74,0,77,0,85,0,0,0,174,0,3,0,71,0,121,0,31,0,214,0,118,0,251,0,191,0,167,0,232,0,74,0,204,0,179,0,123,0,169,0,0,0,57,0,215,0,164,0,2,0,3,0,94,0,132,0,0,0,248,0,127,0,8,0,0,0,32,0,89,0,3,0,72,0,166,0,124,0,99,0,110,0,74,0,168,0,253,0,43,0,70,0,201,0,211,0,0,0,0,0,161,0,61,0,204,0,205,0,114,0,254,0,242,0,2,0,226,0,157,0,182,0,90,0,183,0,0,0,0,0,147,0,163,0,143,0,199,0,0,0,171,0,123,0,75,0,94,0,26,0,158,0,91,0,0,0,0,0,76,0,214,0,242,0,83,0,87,0,207,0,128,0,157,0,158,0,158,0,204,0,108,0,111,0,10,0,138,0,0,0,0,0,204,0,238,0,71,0,0,0,215,0,120,0,108,0,84,0,0,0,18,0,0,0,154,0,221,0,136,0,78,0,41,0,65,0,62,0,245,0,162,0,26,0,0,0,12,0,14,0,24,0,0,0,0,0,165,0,220,0,138,0,152,0,50,0,89,0,0,0,67,0,0,0,112,0,0,0,19,0,72,0,53,0,105,0,48,0,64,0,12,0,233,0,57,0,0,0,4,0,0,0,0,0,0,0,0,0,63,0,116,0,249,0,0,0,142,0,0,0,22,0,160,0,190,0,120,0,40,0,0,0,205,0,255,0,0,0,61,0,252,0,215,0,65,0,92,0,40,0,176,0,93,0,164,0,53,0,0,0,238,0,217,0,39,0,197,0,0,0,186,0,0,0,135,0,6,0,92,0,92,0,49,0,0,0,12,0,74,0,95,0,73,0,0,0,74,0,0,0,135,0,0,0,245,0,120,0,113,0,231,0,78,0,0,0,65,0,52,0,194,0,151,0,180,0,0,0,236,0,71,0,124,0,8,0,144,0,213,0,232,0,80,0,236,0,38,0,249,0,52,0,123,0,201,0,23,0,157,0,211,0,77,0,99,0,163,0,159,0,244,0,91,0,0,0,0,0,0,0,0,0,227,0,183,0,57,0,83,0,71,0,5,0,232,0,205,0,0,0,157,0,0,0,7,0,97,0,73,0,58,0,39,0,90,0,138,0,225,0,0,0,87,0,242,0,75,0,220,0,131,0,11,0,0,0,217,0,56,0,220,0,160,0,76,0,159,0,237,0,0,0,0,0,183,0,242,0,249,0,57,0,0,0,72,0,154,0,0,0,0,0,81,0,195,0,96,0,19,0,0,0,70,0,107,0,0,0,0,0,8,0,59,0,164,0,133,0,61,0,172,0,68,0,80,0,12,0,184,0,84,0,51,0,169,0,31,0,116,0,0,0,0,0,0,0,89,0,245,0,35,0,190,0,127,0,0,0,95,0,94,0,174,0,0,0,196,0,193,0,0,0,2,0,0,0,15,0,39,0,15,0,0,0,127,0,149,0,8,0,0,0,140,0,86,0,0,0,255,0);
signal scenario_full  : scenario_type := (122,31,196,31,203,31,97,31,213,31,216,31,65,31,118,31,225,31,46,31,215,31,38,31,184,31,184,30,38,31,63,31,195,31,216,31,240,31,110,31,211,31,211,30,192,31,74,31,108,31,36,31,36,30,9,31,180,31,180,30,69,31,220,31,245,31,9,31,15,31,177,31,168,31,65,31,17,31,73,31,73,30,234,31,206,31,132,31,177,31,21,31,65,31,182,31,12,31,222,31,79,31,226,31,74,31,158,31,27,31,181,31,53,31,184,31,109,31,109,30,5,31,5,30,54,31,51,31,73,31,56,31,56,30,253,31,38,31,112,31,112,30,142,31,142,31,103,31,195,31,164,31,231,31,88,31,75,31,76,31,76,30,76,29,96,31,210,31,7,31,7,30,7,29,165,31,4,31,144,31,125,31,125,30,125,29,253,31,54,31,248,31,105,31,105,30,42,31,79,31,211,31,114,31,131,31,23,31,215,31,215,30,105,31,76,31,76,30,23,31,62,31,218,31,66,31,196,31,196,30,81,31,74,31,77,31,85,31,85,30,174,31,3,31,71,31,121,31,31,31,214,31,118,31,251,31,191,31,167,31,232,31,74,31,204,31,179,31,123,31,169,31,169,30,57,31,215,31,164,31,2,31,3,31,94,31,132,31,132,30,248,31,127,31,8,31,8,30,32,31,89,31,3,31,72,31,166,31,124,31,99,31,110,31,74,31,168,31,253,31,43,31,70,31,201,31,211,31,211,30,211,29,161,31,61,31,204,31,205,31,114,31,254,31,242,31,2,31,226,31,157,31,182,31,90,31,183,31,183,30,183,29,147,31,163,31,143,31,199,31,199,30,171,31,123,31,75,31,94,31,26,31,158,31,91,31,91,30,91,29,76,31,214,31,242,31,83,31,87,31,207,31,128,31,157,31,158,31,158,31,204,31,108,31,111,31,10,31,138,31,138,30,138,29,204,31,238,31,71,31,71,30,215,31,120,31,108,31,84,31,84,30,18,31,18,30,154,31,221,31,136,31,78,31,41,31,65,31,62,31,245,31,162,31,26,31,26,30,12,31,14,31,24,31,24,30,24,29,165,31,220,31,138,31,152,31,50,31,89,31,89,30,67,31,67,30,112,31,112,30,19,31,72,31,53,31,105,31,48,31,64,31,12,31,233,31,57,31,57,30,4,31,4,30,4,29,4,28,4,27,63,31,116,31,249,31,249,30,142,31,142,30,22,31,160,31,190,31,120,31,40,31,40,30,205,31,255,31,255,30,61,31,252,31,215,31,65,31,92,31,40,31,176,31,93,31,164,31,53,31,53,30,238,31,217,31,39,31,197,31,197,30,186,31,186,30,135,31,6,31,92,31,92,31,49,31,49,30,12,31,74,31,95,31,73,31,73,30,74,31,74,30,135,31,135,30,245,31,120,31,113,31,231,31,78,31,78,30,65,31,52,31,194,31,151,31,180,31,180,30,236,31,71,31,124,31,8,31,144,31,213,31,232,31,80,31,236,31,38,31,249,31,52,31,123,31,201,31,23,31,157,31,211,31,77,31,99,31,163,31,159,31,244,31,91,31,91,30,91,29,91,28,91,27,227,31,183,31,57,31,83,31,71,31,5,31,232,31,205,31,205,30,157,31,157,30,7,31,97,31,73,31,58,31,39,31,90,31,138,31,225,31,225,30,87,31,242,31,75,31,220,31,131,31,11,31,11,30,217,31,56,31,220,31,160,31,76,31,159,31,237,31,237,30,237,29,183,31,242,31,249,31,57,31,57,30,72,31,154,31,154,30,154,29,81,31,195,31,96,31,19,31,19,30,70,31,107,31,107,30,107,29,8,31,59,31,164,31,133,31,61,31,172,31,68,31,80,31,12,31,184,31,84,31,51,31,169,31,31,31,116,31,116,30,116,29,116,28,89,31,245,31,35,31,190,31,127,31,127,30,95,31,94,31,174,31,174,30,196,31,193,31,193,30,2,31,2,30,15,31,39,31,15,31,15,30,127,31,149,31,8,31,8,30,140,31,86,31,86,30,255,31);

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
