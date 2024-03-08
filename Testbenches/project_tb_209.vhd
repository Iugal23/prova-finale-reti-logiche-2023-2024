-- TB EXAMPLE PFRL 2023-2024

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use std.textio.all;

entity project_tb_209 is
end project_tb_209;

architecture project_tb_arch_209 of project_tb_209 is
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

constant SCENARIO_LENGTH : integer := 212;
    type scenario_type is array (0 to SCENARIO_LENGTH*2-1) of integer;

signal scenario_input : scenario_type := (54,0,26,0,109,0,17,0,89,0,2,0,205,0,225,0,51,0,159,0,0,0,23,0,54,0,0,0,0,0,73,0,118,0,109,0,0,0,0,0,47,0,88,0,230,0,196,0,174,0,121,0,102,0,80,0,0,0,0,0,73,0,0,0,177,0,55,0,0,0,97,0,0,0,173,0,225,0,186,0,34,0,132,0,53,0,38,0,22,0,144,0,102,0,90,0,159,0,0,0,191,0,0,0,176,0,0,0,216,0,235,0,74,0,246,0,43,0,36,0,46,0,203,0,118,0,178,0,219,0,106,0,4,0,27,0,149,0,77,0,41,0,31,0,0,0,156,0,0,0,0,0,207,0,30,0,136,0,19,0,93,0,123,0,192,0,183,0,106,0,86,0,0,0,0,0,164,0,33,0,2,0,230,0,159,0,141,0,123,0,116,0,142,0,140,0,0,0,71,0,199,0,25,0,0,0,56,0,241,0,39,0,139,0,96,0,128,0,224,0,93,0,102,0,52,0,187,0,31,0,0,0,135,0,0,0,41,0,83,0,240,0,0,0,0,0,61,0,177,0,21,0,0,0,219,0,100,0,231,0,8,0,182,0,0,0,19,0,211,0,230,0,0,0,52,0,21,0,0,0,0,0,178,0,0,0,23,0,0,0,0,0,190,0,70,0,0,0,199,0,114,0,100,0,200,0,174,0,203,0,0,0,223,0,188,0,0,0,154,0,38,0,0,0,161,0,206,0,86,0,19,0,0,0,0,0,118,0,0,0,162,0,166,0,0,0,29,0,226,0,147,0,81,0,167,0,104,0,0,0,66,0,203,0,40,0,104,0,102,0,228,0,0,0,72,0,79,0,229,0,108,0,102,0,39,0,165,0,80,0,0,0,162,0,218,0,198,0,0,0,152,0,51,0,0,0,221,0,41,0,205,0,221,0,196,0,173,0,220,0,121,0,19,0);
signal scenario_full  : scenario_type := (54,31,26,31,109,31,17,31,89,31,2,31,205,31,225,31,51,31,159,31,159,30,23,31,54,31,54,30,54,29,73,31,118,31,109,31,109,30,109,29,47,31,88,31,230,31,196,31,174,31,121,31,102,31,80,31,80,30,80,29,73,31,73,30,177,31,55,31,55,30,97,31,97,30,173,31,225,31,186,31,34,31,132,31,53,31,38,31,22,31,144,31,102,31,90,31,159,31,159,30,191,31,191,30,176,31,176,30,216,31,235,31,74,31,246,31,43,31,36,31,46,31,203,31,118,31,178,31,219,31,106,31,4,31,27,31,149,31,77,31,41,31,31,31,31,30,156,31,156,30,156,29,207,31,30,31,136,31,19,31,93,31,123,31,192,31,183,31,106,31,86,31,86,30,86,29,164,31,33,31,2,31,230,31,159,31,141,31,123,31,116,31,142,31,140,31,140,30,71,31,199,31,25,31,25,30,56,31,241,31,39,31,139,31,96,31,128,31,224,31,93,31,102,31,52,31,187,31,31,31,31,30,135,31,135,30,41,31,83,31,240,31,240,30,240,29,61,31,177,31,21,31,21,30,219,31,100,31,231,31,8,31,182,31,182,30,19,31,211,31,230,31,230,30,52,31,21,31,21,30,21,29,178,31,178,30,23,31,23,30,23,29,190,31,70,31,70,30,199,31,114,31,100,31,200,31,174,31,203,31,203,30,223,31,188,31,188,30,154,31,38,31,38,30,161,31,206,31,86,31,19,31,19,30,19,29,118,31,118,30,162,31,166,31,166,30,29,31,226,31,147,31,81,31,167,31,104,31,104,30,66,31,203,31,40,31,104,31,102,31,228,31,228,30,72,31,79,31,229,31,108,31,102,31,39,31,165,31,80,31,80,30,162,31,218,31,198,31,198,30,152,31,51,31,51,30,221,31,41,31,205,31,221,31,196,31,173,31,220,31,121,31,19,31);

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
