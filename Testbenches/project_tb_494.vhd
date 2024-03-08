-- TB EXAMPLE PFRL 2023-2024

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use std.textio.all;

entity project_tb_494 is
end project_tb_494;

architecture project_tb_arch_494 of project_tb_494 is
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

constant SCENARIO_LENGTH : integer := 225;
    type scenario_type is array (0 to SCENARIO_LENGTH*2-1) of integer;

signal scenario_input : scenario_type := (211,0,184,0,1,0,131,0,80,0,142,0,169,0,240,0,99,0,70,0,80,0,56,0,118,0,221,0,0,0,209,0,74,0,36,0,0,0,176,0,118,0,0,0,129,0,192,0,116,0,0,0,249,0,17,0,0,0,27,0,0,0,0,0,0,0,44,0,106,0,222,0,193,0,224,0,87,0,146,0,89,0,0,0,174,0,124,0,64,0,83,0,157,0,171,0,89,0,0,0,128,0,227,0,9,0,0,0,0,0,76,0,209,0,58,0,225,0,125,0,199,0,0,0,11,0,127,0,208,0,196,0,231,0,147,0,0,0,162,0,0,0,6,0,103,0,84,0,71,0,0,0,128,0,0,0,156,0,158,0,0,0,39,0,0,0,74,0,135,0,21,0,52,0,19,0,207,0,95,0,250,0,70,0,124,0,251,0,211,0,31,0,47,0,0,0,47,0,52,0,79,0,173,0,206,0,48,0,90,0,53,0,32,0,189,0,146,0,227,0,0,0,173,0,100,0,9,0,0,0,244,0,118,0,33,0,169,0,226,0,30,0,0,0,213,0,0,0,0,0,199,0,0,0,44,0,123,0,0,0,141,0,206,0,69,0,0,0,113,0,54,0,135,0,11,0,63,0,174,0,112,0,0,0,252,0,184,0,180,0,25,0,36,0,156,0,126,0,204,0,0,0,0,0,131,0,70,0,109,0,0,0,120,0,32,0,161,0,88,0,146,0,214,0,28,0,194,0,86,0,216,0,242,0,0,0,167,0,209,0,0,0,0,0,183,0,205,0,89,0,150,0,26,0,58,0,175,0,12,0,0,0,0,0,242,0,0,0,147,0,151,0,0,0,0,0,164,0,205,0,234,0,90,0,43,0,46,0,5,0,65,0,100,0,66,0,232,0,250,0,0,0,69,0,241,0,138,0,204,0,151,0,215,0,183,0,221,0,209,0,242,0,95,0,216,0,41,0,13,0,0,0,108,0,151,0,207,0,37,0,0,0,56,0,166,0,221,0,52,0);
signal scenario_full  : scenario_type := (211,31,184,31,1,31,131,31,80,31,142,31,169,31,240,31,99,31,70,31,80,31,56,31,118,31,221,31,221,30,209,31,74,31,36,31,36,30,176,31,118,31,118,30,129,31,192,31,116,31,116,30,249,31,17,31,17,30,27,31,27,30,27,29,27,28,44,31,106,31,222,31,193,31,224,31,87,31,146,31,89,31,89,30,174,31,124,31,64,31,83,31,157,31,171,31,89,31,89,30,128,31,227,31,9,31,9,30,9,29,76,31,209,31,58,31,225,31,125,31,199,31,199,30,11,31,127,31,208,31,196,31,231,31,147,31,147,30,162,31,162,30,6,31,103,31,84,31,71,31,71,30,128,31,128,30,156,31,158,31,158,30,39,31,39,30,74,31,135,31,21,31,52,31,19,31,207,31,95,31,250,31,70,31,124,31,251,31,211,31,31,31,47,31,47,30,47,31,52,31,79,31,173,31,206,31,48,31,90,31,53,31,32,31,189,31,146,31,227,31,227,30,173,31,100,31,9,31,9,30,244,31,118,31,33,31,169,31,226,31,30,31,30,30,213,31,213,30,213,29,199,31,199,30,44,31,123,31,123,30,141,31,206,31,69,31,69,30,113,31,54,31,135,31,11,31,63,31,174,31,112,31,112,30,252,31,184,31,180,31,25,31,36,31,156,31,126,31,204,31,204,30,204,29,131,31,70,31,109,31,109,30,120,31,32,31,161,31,88,31,146,31,214,31,28,31,194,31,86,31,216,31,242,31,242,30,167,31,209,31,209,30,209,29,183,31,205,31,89,31,150,31,26,31,58,31,175,31,12,31,12,30,12,29,242,31,242,30,147,31,151,31,151,30,151,29,164,31,205,31,234,31,90,31,43,31,46,31,5,31,65,31,100,31,66,31,232,31,250,31,250,30,69,31,241,31,138,31,204,31,151,31,215,31,183,31,221,31,209,31,242,31,95,31,216,31,41,31,13,31,13,30,108,31,151,31,207,31,37,31,37,30,56,31,166,31,221,31,52,31);

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
