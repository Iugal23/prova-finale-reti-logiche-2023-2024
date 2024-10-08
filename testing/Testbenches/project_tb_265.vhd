-- TB EXAMPLE PFRL 2023-2024

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use std.textio.all;

entity project_tb_265 is
end project_tb_265;

architecture project_tb_arch_265 of project_tb_265 is
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

constant SCENARIO_LENGTH : integer := 370;
    type scenario_type is array (0 to SCENARIO_LENGTH*2-1) of integer;

signal scenario_input : scenario_type := (178,0,43,0,145,0,0,0,0,0,53,0,71,0,76,0,147,0,0,0,164,0,63,0,158,0,80,0,240,0,192,0,148,0,249,0,252,0,148,0,56,0,0,0,27,0,114,0,221,0,179,0,74,0,66,0,176,0,14,0,129,0,192,0,202,0,31,0,214,0,139,0,236,0,0,0,220,0,0,0,138,0,99,0,0,0,84,0,202,0,0,0,238,0,4,0,40,0,12,0,123,0,172,0,31,0,224,0,88,0,83,0,0,0,60,0,140,0,104,0,0,0,112,0,65,0,0,0,103,0,105,0,75,0,166,0,211,0,206,0,0,0,0,0,45,0,203,0,117,0,120,0,57,0,47,0,0,0,188,0,183,0,224,0,175,0,167,0,0,0,178,0,0,0,24,0,54,0,30,0,6,0,193,0,34,0,19,0,241,0,255,0,44,0,0,0,202,0,0,0,34,0,245,0,237,0,87,0,141,0,0,0,61,0,161,0,170,0,0,0,223,0,231,0,241,0,173,0,160,0,0,0,106,0,222,0,15,0,244,0,195,0,56,0,0,0,231,0,47,0,200,0,249,0,204,0,159,0,153,0,51,0,0,0,0,0,0,0,164,0,0,0,77,0,244,0,141,0,139,0,91,0,216,0,121,0,230,0,200,0,111,0,45,0,152,0,210,0,125,0,60,0,23,0,12,0,38,0,118,0,116,0,218,0,234,0,6,0,72,0,66,0,173,0,255,0,15,0,20,0,44,0,106,0,63,0,34,0,56,0,0,0,249,0,0,0,204,0,87,0,79,0,0,0,22,0,196,0,167,0,56,0,0,0,110,0,0,0,0,0,7,0,235,0,0,0,0,0,14,0,119,0,226,0,115,0,248,0,9,0,0,0,0,0,34,0,68,0,97,0,0,0,65,0,231,0,55,0,88,0,21,0,30,0,211,0,41,0,242,0,0,0,117,0,204,0,232,0,97,0,115,0,216,0,54,0,103,0,82,0,95,0,13,0,128,0,223,0,0,0,154,0,135,0,252,0,2,0,163,0,164,0,42,0,36,0,20,0,0,0,216,0,0,0,215,0,253,0,0,0,0,0,0,0,67,0,132,0,171,0,171,0,213,0,0,0,166,0,78,0,239,0,0,0,62,0,236,0,12,0,218,0,124,0,255,0,213,0,111,0,47,0,0,0,150,0,74,0,0,0,100,0,254,0,117,0,0,0,117,0,0,0,108,0,55,0,0,0,16,0,0,0,203,0,10,0,161,0,87,0,0,0,82,0,100,0,178,0,110,0,14,0,249,0,91,0,45,0,226,0,107,0,3,0,203,0,236,0,0,0,84,0,200,0,77,0,80,0,0,0,67,0,0,0,0,0,225,0,197,0,200,0,199,0,77,0,26,0,4,0,0,0,0,0,140,0,61,0,192,0,201,0,7,0,103,0,191,0,3,0,38,0,216,0,205,0,177,0,81,0,218,0,163,0,19,0,103,0,49,0,164,0,185,0,150,0,0,0,0,0,65,0,0,0,0,0,227,0,24,0,251,0,238,0,107,0,0,0,0,0,0,0,77,0,0,0,149,0,108,0,66,0,246,0,37,0,71,0,232,0,255,0,0,0,246,0,148,0,151,0,0,0,230,0,51,0,184,0,216,0,169,0,0,0,180,0,237,0,0,0);
signal scenario_full  : scenario_type := (178,31,43,31,145,31,145,30,145,29,53,31,71,31,76,31,147,31,147,30,164,31,63,31,158,31,80,31,240,31,192,31,148,31,249,31,252,31,148,31,56,31,56,30,27,31,114,31,221,31,179,31,74,31,66,31,176,31,14,31,129,31,192,31,202,31,31,31,214,31,139,31,236,31,236,30,220,31,220,30,138,31,99,31,99,30,84,31,202,31,202,30,238,31,4,31,40,31,12,31,123,31,172,31,31,31,224,31,88,31,83,31,83,30,60,31,140,31,104,31,104,30,112,31,65,31,65,30,103,31,105,31,75,31,166,31,211,31,206,31,206,30,206,29,45,31,203,31,117,31,120,31,57,31,47,31,47,30,188,31,183,31,224,31,175,31,167,31,167,30,178,31,178,30,24,31,54,31,30,31,6,31,193,31,34,31,19,31,241,31,255,31,44,31,44,30,202,31,202,30,34,31,245,31,237,31,87,31,141,31,141,30,61,31,161,31,170,31,170,30,223,31,231,31,241,31,173,31,160,31,160,30,106,31,222,31,15,31,244,31,195,31,56,31,56,30,231,31,47,31,200,31,249,31,204,31,159,31,153,31,51,31,51,30,51,29,51,28,164,31,164,30,77,31,244,31,141,31,139,31,91,31,216,31,121,31,230,31,200,31,111,31,45,31,152,31,210,31,125,31,60,31,23,31,12,31,38,31,118,31,116,31,218,31,234,31,6,31,72,31,66,31,173,31,255,31,15,31,20,31,44,31,106,31,63,31,34,31,56,31,56,30,249,31,249,30,204,31,87,31,79,31,79,30,22,31,196,31,167,31,56,31,56,30,110,31,110,30,110,29,7,31,235,31,235,30,235,29,14,31,119,31,226,31,115,31,248,31,9,31,9,30,9,29,34,31,68,31,97,31,97,30,65,31,231,31,55,31,88,31,21,31,30,31,211,31,41,31,242,31,242,30,117,31,204,31,232,31,97,31,115,31,216,31,54,31,103,31,82,31,95,31,13,31,128,31,223,31,223,30,154,31,135,31,252,31,2,31,163,31,164,31,42,31,36,31,20,31,20,30,216,31,216,30,215,31,253,31,253,30,253,29,253,28,67,31,132,31,171,31,171,31,213,31,213,30,166,31,78,31,239,31,239,30,62,31,236,31,12,31,218,31,124,31,255,31,213,31,111,31,47,31,47,30,150,31,74,31,74,30,100,31,254,31,117,31,117,30,117,31,117,30,108,31,55,31,55,30,16,31,16,30,203,31,10,31,161,31,87,31,87,30,82,31,100,31,178,31,110,31,14,31,249,31,91,31,45,31,226,31,107,31,3,31,203,31,236,31,236,30,84,31,200,31,77,31,80,31,80,30,67,31,67,30,67,29,225,31,197,31,200,31,199,31,77,31,26,31,4,31,4,30,4,29,140,31,61,31,192,31,201,31,7,31,103,31,191,31,3,31,38,31,216,31,205,31,177,31,81,31,218,31,163,31,19,31,103,31,49,31,164,31,185,31,150,31,150,30,150,29,65,31,65,30,65,29,227,31,24,31,251,31,238,31,107,31,107,30,107,29,107,28,77,31,77,30,149,31,108,31,66,31,246,31,37,31,71,31,232,31,255,31,255,30,246,31,148,31,151,31,151,30,230,31,51,31,184,31,216,31,169,31,169,30,180,31,237,31,237,30);

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
