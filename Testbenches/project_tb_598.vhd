-- TB EXAMPLE PFRL 2023-2024

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use std.textio.all;

entity project_tb_598 is
end project_tb_598;

architecture project_tb_arch_598 of project_tb_598 is
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

constant SCENARIO_LENGTH : integer := 305;
    type scenario_type is array (0 to SCENARIO_LENGTH*2-1) of integer;

signal scenario_input : scenario_type := (240,0,120,0,107,0,190,0,0,0,45,0,0,0,96,0,181,0,0,0,0,0,135,0,35,0,92,0,147,0,164,0,122,0,251,0,231,0,217,0,151,0,112,0,23,0,180,0,19,0,0,0,34,0,41,0,0,0,229,0,0,0,148,0,243,0,230,0,47,0,65,0,168,0,36,0,211,0,31,0,114,0,220,0,196,0,104,0,20,0,13,0,21,0,152,0,0,0,232,0,107,0,54,0,91,0,78,0,87,0,99,0,162,0,223,0,24,0,139,0,82,0,48,0,187,0,37,0,46,0,15,0,178,0,52,0,0,0,167,0,61,0,159,0,17,0,186,0,161,0,65,0,54,0,0,0,0,0,66,0,33,0,114,0,135,0,172,0,110,0,72,0,0,0,71,0,65,0,182,0,19,0,24,0,0,0,57,0,99,0,0,0,0,0,243,0,59,0,107,0,62,0,248,0,88,0,239,0,205,0,133,0,144,0,147,0,218,0,59,0,33,0,47,0,45,0,141,0,0,0,125,0,43,0,152,0,84,0,232,0,241,0,78,0,146,0,0,0,0,0,0,0,118,0,10,0,158,0,0,0,38,0,178,0,139,0,35,0,54,0,132,0,5,0,28,0,167,0,103,0,131,0,183,0,11,0,33,0,199,0,89,0,228,0,0,0,242,0,205,0,0,0,206,0,223,0,18,0,0,0,173,0,0,0,12,0,0,0,67,0,35,0,142,0,60,0,17,0,40,0,182,0,0,0,186,0,209,0,26,0,140,0,141,0,197,0,154,0,7,0,0,0,237,0,106,0,146,0,40,0,205,0,219,0,229,0,0,0,0,0,169,0,82,0,103,0,0,0,149,0,251,0,22,0,236,0,67,0,8,0,216,0,139,0,0,0,182,0,146,0,12,0,132,0,0,0,110,0,119,0,210,0,5,0,215,0,0,0,211,0,0,0,68,0,126,0,84,0,213,0,153,0,100,0,89,0,14,0,184,0,133,0,46,0,158,0,57,0,189,0,158,0,203,0,193,0,83,0,51,0,216,0,0,0,36,0,254,0,185,0,78,0,217,0,0,0,162,0,252,0,0,0,245,0,0,0,90,0,16,0,104,0,0,0,65,0,0,0,131,0,32,0,0,0,116,0,185,0,250,0,228,0,74,0,113,0,115,0,49,0,211,0,186,0,14,0,0,0,188,0,218,0,23,0,54,0,126,0,129,0,184,0,155,0,189,0,121,0,215,0,19,0,141,0,0,0,86,0,53,0,123,0,0,0,3,0,111,0,175,0,63,0,0,0,204,0,53,0,239,0,229,0,211,0,132,0,0,0,0,0,196,0,188,0,56,0,103,0,66,0,5,0,100,0,115,0,171,0,94,0);
signal scenario_full  : scenario_type := (240,31,120,31,107,31,190,31,190,30,45,31,45,30,96,31,181,31,181,30,181,29,135,31,35,31,92,31,147,31,164,31,122,31,251,31,231,31,217,31,151,31,112,31,23,31,180,31,19,31,19,30,34,31,41,31,41,30,229,31,229,30,148,31,243,31,230,31,47,31,65,31,168,31,36,31,211,31,31,31,114,31,220,31,196,31,104,31,20,31,13,31,21,31,152,31,152,30,232,31,107,31,54,31,91,31,78,31,87,31,99,31,162,31,223,31,24,31,139,31,82,31,48,31,187,31,37,31,46,31,15,31,178,31,52,31,52,30,167,31,61,31,159,31,17,31,186,31,161,31,65,31,54,31,54,30,54,29,66,31,33,31,114,31,135,31,172,31,110,31,72,31,72,30,71,31,65,31,182,31,19,31,24,31,24,30,57,31,99,31,99,30,99,29,243,31,59,31,107,31,62,31,248,31,88,31,239,31,205,31,133,31,144,31,147,31,218,31,59,31,33,31,47,31,45,31,141,31,141,30,125,31,43,31,152,31,84,31,232,31,241,31,78,31,146,31,146,30,146,29,146,28,118,31,10,31,158,31,158,30,38,31,178,31,139,31,35,31,54,31,132,31,5,31,28,31,167,31,103,31,131,31,183,31,11,31,33,31,199,31,89,31,228,31,228,30,242,31,205,31,205,30,206,31,223,31,18,31,18,30,173,31,173,30,12,31,12,30,67,31,35,31,142,31,60,31,17,31,40,31,182,31,182,30,186,31,209,31,26,31,140,31,141,31,197,31,154,31,7,31,7,30,237,31,106,31,146,31,40,31,205,31,219,31,229,31,229,30,229,29,169,31,82,31,103,31,103,30,149,31,251,31,22,31,236,31,67,31,8,31,216,31,139,31,139,30,182,31,146,31,12,31,132,31,132,30,110,31,119,31,210,31,5,31,215,31,215,30,211,31,211,30,68,31,126,31,84,31,213,31,153,31,100,31,89,31,14,31,184,31,133,31,46,31,158,31,57,31,189,31,158,31,203,31,193,31,83,31,51,31,216,31,216,30,36,31,254,31,185,31,78,31,217,31,217,30,162,31,252,31,252,30,245,31,245,30,90,31,16,31,104,31,104,30,65,31,65,30,131,31,32,31,32,30,116,31,185,31,250,31,228,31,74,31,113,31,115,31,49,31,211,31,186,31,14,31,14,30,188,31,218,31,23,31,54,31,126,31,129,31,184,31,155,31,189,31,121,31,215,31,19,31,141,31,141,30,86,31,53,31,123,31,123,30,3,31,111,31,175,31,63,31,63,30,204,31,53,31,239,31,229,31,211,31,132,31,132,30,132,29,196,31,188,31,56,31,103,31,66,31,5,31,100,31,115,31,171,31,94,31);

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
