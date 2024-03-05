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

constant SCENARIO_LENGTH : integer := 163;
    type scenario_type is array (0 to SCENARIO_LENGTH*2-1) of integer;

signal scenario_input : scenario_type := (236,0,230,0,225,0,0,0,124,0,169,0,232,0,124,0,0,0,0,0,195,0,134,0,230,0,169,0,219,0,209,0,34,0,36,0,2,0,185,0,1,0,0,0,137,0,120,0,176,0,159,0,21,0,202,0,213,0,109,0,44,0,0,0,0,0,0,0,192,0,224,0,7,0,96,0,0,0,119,0,216,0,138,0,200,0,168,0,152,0,3,0,20,0,0,0,60,0,1,0,251,0,0,0,236,0,112,0,20,0,220,0,0,0,71,0,8,0,165,0,112,0,106,0,234,0,149,0,211,0,60,0,0,0,93,0,71,0,50,0,148,0,224,0,221,0,211,0,22,0,45,0,244,0,49,0,214,0,196,0,0,0,154,0,164,0,173,0,242,0,47,0,207,0,0,0,213,0,240,0,216,0,2,0,0,0,26,0,0,0,0,0,0,0,56,0,26,0,1,0,73,0,243,0,0,0,251,0,145,0,183,0,68,0,253,0,68,0,5,0,59,0,174,0,137,0,161,0,235,0,21,0,0,0,75,0,0,0,234,0,40,0,183,0,104,0,183,0,164,0,179,0,148,0,19,0,211,0,0,0,179,0,117,0,107,0,52,0,27,0,173,0,29,0,119,0,105,0,49,0,204,0,0,0,0,0,205,0,86,0,101,0,0,0,58,0,32,0,132,0,0,0,0,0,0,0,52,0,128,0,177,0,0,0,138,0,28,0,50,0,206,0,32,0,85,0);
signal scenario_full  : scenario_type := (236,31,230,31,225,31,225,30,124,31,169,31,232,31,124,31,124,30,124,29,195,31,134,31,230,31,169,31,219,31,209,31,34,31,36,31,2,31,185,31,1,31,1,30,137,31,120,31,176,31,159,31,21,31,202,31,213,31,109,31,44,31,44,30,44,29,44,28,192,31,224,31,7,31,96,31,96,30,119,31,216,31,138,31,200,31,168,31,152,31,3,31,20,31,20,30,60,31,1,31,251,31,251,30,236,31,112,31,20,31,220,31,220,30,71,31,8,31,165,31,112,31,106,31,234,31,149,31,211,31,60,31,60,30,93,31,71,31,50,31,148,31,224,31,221,31,211,31,22,31,45,31,244,31,49,31,214,31,196,31,196,30,154,31,164,31,173,31,242,31,47,31,207,31,207,30,213,31,240,31,216,31,2,31,2,30,26,31,26,30,26,29,26,28,56,31,26,31,1,31,73,31,243,31,243,30,251,31,145,31,183,31,68,31,253,31,68,31,5,31,59,31,174,31,137,31,161,31,235,31,21,31,21,30,75,31,75,30,234,31,40,31,183,31,104,31,183,31,164,31,179,31,148,31,19,31,211,31,211,30,179,31,117,31,107,31,52,31,27,31,173,31,29,31,119,31,105,31,49,31,204,31,204,30,204,29,205,31,86,31,101,31,101,30,58,31,32,31,132,31,132,30,132,29,132,28,52,31,128,31,177,31,177,30,138,31,28,31,50,31,206,31,32,31,85,31);

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
