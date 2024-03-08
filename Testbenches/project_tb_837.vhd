-- TB EXAMPLE PFRL 2023-2024

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use std.textio.all;

entity project_tb_837 is
end project_tb_837;

architecture project_tb_arch_837 of project_tb_837 is
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

constant SCENARIO_LENGTH : integer := 364;
    type scenario_type is array (0 to SCENARIO_LENGTH*2-1) of integer;

signal scenario_input : scenario_type := (56,0,214,0,168,0,89,0,0,0,168,0,231,0,164,0,0,0,0,0,236,0,233,0,0,0,224,0,6,0,89,0,150,0,215,0,151,0,18,0,54,0,0,0,38,0,247,0,112,0,65,0,11,0,29,0,135,0,0,0,222,0,121,0,0,0,227,0,63,0,52,0,123,0,128,0,140,0,243,0,48,0,73,0,53,0,45,0,0,0,177,0,231,0,171,0,52,0,0,0,160,0,8,0,219,0,146,0,110,0,115,0,14,0,52,0,31,0,0,0,208,0,235,0,13,0,0,0,0,0,163,0,157,0,20,0,75,0,107,0,215,0,154,0,0,0,0,0,161,0,87,0,68,0,154,0,0,0,206,0,220,0,240,0,121,0,164,0,137,0,193,0,204,0,0,0,0,0,100,0,0,0,78,0,0,0,152,0,234,0,105,0,0,0,173,0,92,0,0,0,208,0,246,0,123,0,0,0,22,0,135,0,179,0,21,0,0,0,0,0,52,0,199,0,103,0,234,0,40,0,16,0,0,0,108,0,106,0,0,0,81,0,198,0,49,0,0,0,135,0,182,0,96,0,163,0,0,0,73,0,246,0,0,0,81,0,131,0,220,0,114,0,84,0,112,0,0,0,131,0,88,0,221,0,216,0,11,0,119,0,99,0,186,0,33,0,249,0,0,0,164,0,107,0,235,0,0,0,98,0,5,0,186,0,111,0,0,0,12,0,0,0,124,0,126,0,161,0,96,0,95,0,74,0,0,0,0,0,30,0,9,0,0,0,185,0,85,0,248,0,0,0,236,0,149,0,0,0,112,0,243,0,149,0,0,0,103,0,130,0,46,0,213,0,190,0,34,0,16,0,0,0,0,0,6,0,0,0,207,0,86,0,73,0,75,0,127,0,241,0,126,0,29,0,160,0,86,0,161,0,28,0,0,0,128,0,0,0,150,0,107,0,118,0,172,0,209,0,239,0,0,0,104,0,0,0,215,0,245,0,0,0,121,0,81,0,97,0,51,0,38,0,0,0,0,0,0,0,106,0,177,0,189,0,152,0,35,0,195,0,140,0,99,0,197,0,0,0,17,0,165,0,138,0,0,0,0,0,144,0,0,0,171,0,225,0,83,0,121,0,176,0,0,0,155,0,62,0,47,0,40,0,96,0,155,0,76,0,130,0,237,0,0,0,245,0,48,0,244,0,18,0,11,0,0,0,234,0,6,0,129,0,0,0,189,0,125,0,147,0,0,0,38,0,108,0,222,0,182,0,181,0,137,0,126,0,83,0,12,0,189,0,0,0,103,0,184,0,98,0,58,0,41,0,0,0,163,0,108,0,57,0,189,0,176,0,182,0,0,0,204,0,156,0,88,0,215,0,240,0,83,0,163,0,25,0,110,0,0,0,0,0,0,0,111,0,237,0,0,0,26,0,64,0,160,0,223,0,7,0,0,0,209,0,0,0,58,0,54,0,236,0,0,0,177,0,119,0,18,0,251,0,237,0,246,0,61,0,0,0,74,0,241,0,0,0,0,0,3,0,205,0,245,0,129,0,0,0,84,0,139,0,15,0,235,0,0,0,209,0,21,0,120,0,22,0,184,0,96,0,199,0,0,0,172,0,57,0,139,0,205,0,70,0,0,0,167,0);
signal scenario_full  : scenario_type := (56,31,214,31,168,31,89,31,89,30,168,31,231,31,164,31,164,30,164,29,236,31,233,31,233,30,224,31,6,31,89,31,150,31,215,31,151,31,18,31,54,31,54,30,38,31,247,31,112,31,65,31,11,31,29,31,135,31,135,30,222,31,121,31,121,30,227,31,63,31,52,31,123,31,128,31,140,31,243,31,48,31,73,31,53,31,45,31,45,30,177,31,231,31,171,31,52,31,52,30,160,31,8,31,219,31,146,31,110,31,115,31,14,31,52,31,31,31,31,30,208,31,235,31,13,31,13,30,13,29,163,31,157,31,20,31,75,31,107,31,215,31,154,31,154,30,154,29,161,31,87,31,68,31,154,31,154,30,206,31,220,31,240,31,121,31,164,31,137,31,193,31,204,31,204,30,204,29,100,31,100,30,78,31,78,30,152,31,234,31,105,31,105,30,173,31,92,31,92,30,208,31,246,31,123,31,123,30,22,31,135,31,179,31,21,31,21,30,21,29,52,31,199,31,103,31,234,31,40,31,16,31,16,30,108,31,106,31,106,30,81,31,198,31,49,31,49,30,135,31,182,31,96,31,163,31,163,30,73,31,246,31,246,30,81,31,131,31,220,31,114,31,84,31,112,31,112,30,131,31,88,31,221,31,216,31,11,31,119,31,99,31,186,31,33,31,249,31,249,30,164,31,107,31,235,31,235,30,98,31,5,31,186,31,111,31,111,30,12,31,12,30,124,31,126,31,161,31,96,31,95,31,74,31,74,30,74,29,30,31,9,31,9,30,185,31,85,31,248,31,248,30,236,31,149,31,149,30,112,31,243,31,149,31,149,30,103,31,130,31,46,31,213,31,190,31,34,31,16,31,16,30,16,29,6,31,6,30,207,31,86,31,73,31,75,31,127,31,241,31,126,31,29,31,160,31,86,31,161,31,28,31,28,30,128,31,128,30,150,31,107,31,118,31,172,31,209,31,239,31,239,30,104,31,104,30,215,31,245,31,245,30,121,31,81,31,97,31,51,31,38,31,38,30,38,29,38,28,106,31,177,31,189,31,152,31,35,31,195,31,140,31,99,31,197,31,197,30,17,31,165,31,138,31,138,30,138,29,144,31,144,30,171,31,225,31,83,31,121,31,176,31,176,30,155,31,62,31,47,31,40,31,96,31,155,31,76,31,130,31,237,31,237,30,245,31,48,31,244,31,18,31,11,31,11,30,234,31,6,31,129,31,129,30,189,31,125,31,147,31,147,30,38,31,108,31,222,31,182,31,181,31,137,31,126,31,83,31,12,31,189,31,189,30,103,31,184,31,98,31,58,31,41,31,41,30,163,31,108,31,57,31,189,31,176,31,182,31,182,30,204,31,156,31,88,31,215,31,240,31,83,31,163,31,25,31,110,31,110,30,110,29,110,28,111,31,237,31,237,30,26,31,64,31,160,31,223,31,7,31,7,30,209,31,209,30,58,31,54,31,236,31,236,30,177,31,119,31,18,31,251,31,237,31,246,31,61,31,61,30,74,31,241,31,241,30,241,29,3,31,205,31,245,31,129,31,129,30,84,31,139,31,15,31,235,31,235,30,209,31,21,31,120,31,22,31,184,31,96,31,199,31,199,30,172,31,57,31,139,31,205,31,70,31,70,30,167,31);

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
