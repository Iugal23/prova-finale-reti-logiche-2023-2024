-- TB EXAMPLE PFRL 2023-2024

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use std.textio.all;

entity project_tb_712 is
end project_tb_712;

architecture project_tb_arch_712 of project_tb_712 is
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

constant SCENARIO_LENGTH : integer := 510;
    type scenario_type is array (0 to SCENARIO_LENGTH*2-1) of integer;

signal scenario_input : scenario_type := (108,0,239,0,238,0,0,0,0,0,230,0,0,0,87,0,0,0,0,0,52,0,63,0,96,0,109,0,0,0,242,0,177,0,0,0,74,0,0,0,0,0,1,0,198,0,59,0,46,0,62,0,253,0,0,0,53,0,0,0,0,0,193,0,90,0,0,0,24,0,238,0,140,0,211,0,0,0,162,0,181,0,162,0,70,0,226,0,24,0,72,0,20,0,30,0,0,0,123,0,205,0,47,0,0,0,61,0,25,0,0,0,78,0,108,0,221,0,0,0,6,0,0,0,227,0,125,0,32,0,116,0,141,0,141,0,228,0,74,0,96,0,90,0,140,0,99,0,4,0,231,0,84,0,0,0,158,0,103,0,204,0,0,0,44,0,175,0,198,0,47,0,238,0,68,0,149,0,0,0,115,0,25,0,174,0,0,0,86,0,0,0,151,0,88,0,218,0,7,0,149,0,39,0,41,0,19,0,28,0,223,0,0,0,0,0,168,0,25,0,16,0,75,0,109,0,100,0,24,0,76,0,149,0,39,0,94,0,66,0,173,0,0,0,76,0,140,0,198,0,121,0,24,0,0,0,213,0,220,0,26,0,56,0,218,0,195,0,205,0,0,0,195,0,129,0,142,0,134,0,172,0,0,0,142,0,0,0,111,0,144,0,101,0,226,0,155,0,0,0,0,0,141,0,26,0,233,0,146,0,178,0,211,0,221,0,22,0,146,0,0,0,218,0,155,0,44,0,192,0,25,0,0,0,192,0,23,0,196,0,211,0,179,0,7,0,92,0,223,0,254,0,0,0,0,0,160,0,12,0,0,0,134,0,247,0,32,0,164,0,33,0,232,0,189,0,74,0,0,0,137,0,76,0,0,0,53,0,15,0,26,0,130,0,235,0,6,0,119,0,0,0,0,0,215,0,79,0,12,0,0,0,178,0,153,0,29,0,28,0,112,0,177,0,76,0,131,0,0,0,179,0,0,0,238,0,142,0,205,0,156,0,103,0,247,0,0,0,23,0,4,0,220,0,237,0,70,0,233,0,59,0,232,0,91,0,151,0,76,0,0,0,119,0,228,0,0,0,201,0,130,0,175,0,19,0,121,0,120,0,141,0,143,0,228,0,139,0,16,0,147,0,132,0,175,0,215,0,0,0,3,0,6,0,67,0,232,0,80,0,87,0,225,0,7,0,57,0,194,0,3,0,0,0,48,0,104,0,145,0,237,0,0,0,89,0,128,0,84,0,205,0,239,0,210,0,7,0,66,0,12,0,210,0,0,0,144,0,36,0,30,0,0,0,0,0,243,0,85,0,179,0,239,0,197,0,177,0,74,0,113,0,229,0,186,0,76,0,71,0,230,0,198,0,107,0,101,0,238,0,201,0,24,0,251,0,177,0,232,0,5,0,205,0,171,0,136,0,250,0,0,0,155,0,168,0,105,0,29,0,71,0,40,0,0,0,73,0,217,0,171,0,0,0,80,0,183,0,216,0,214,0,172,0,224,0,123,0,0,0,0,0,56,0,148,0,0,0,62,0,0,0,17,0,73,0,117,0,101,0,178,0,206,0,126,0,196,0,0,0,235,0,183,0,0,0,0,0,236,0,231,0,181,0,247,0,97,0,0,0,14,0,24,0,214,0,133,0,50,0,141,0,0,0,154,0,198,0,213,0,82,0,0,0,0,0,192,0,119,0,188,0,0,0,39,0,0,0,34,0,64,0,0,0,0,0,70,0,85,0,0,0,97,0,153,0,183,0,0,0,209,0,16,0,0,0,253,0,0,0,182,0,0,0,31,0,0,0,122,0,19,0,205,0,249,0,0,0,170,0,0,0,186,0,221,0,137,0,0,0,149,0,213,0,108,0,0,0,157,0,182,0,221,0,180,0,5,0,6,0,86,0,13,0,0,0,0,0,112,0,127,0,206,0,231,0,33,0,175,0,126,0,129,0,99,0,141,0,148,0,37,0,66,0,121,0,117,0,112,0,169,0,224,0,107,0,233,0,0,0,79,0,0,0,44,0,19,0,0,0,235,0,253,0,180,0,0,0,25,0,136,0,162,0,90,0,86,0,0,0,147,0,245,0,3,0,28,0,24,0,220,0,0,0,101,0,79,0,73,0,60,0,71,0,117,0,0,0,165,0,253,0,0,0,149,0,161,0,61,0,0,0,56,0,141,0,0,0,24,0,139,0,233,0,0,0,252,0,0,0,77,0,0,0,49,0,57,0,228,0,113,0,170,0,81,0,18,0,145,0,154,0,0,0,38,0,209,0,57,0,157,0,0,0,126,0,97,0,21,0);
signal scenario_full  : scenario_type := (108,31,239,31,238,31,238,30,238,29,230,31,230,30,87,31,87,30,87,29,52,31,63,31,96,31,109,31,109,30,242,31,177,31,177,30,74,31,74,30,74,29,1,31,198,31,59,31,46,31,62,31,253,31,253,30,53,31,53,30,53,29,193,31,90,31,90,30,24,31,238,31,140,31,211,31,211,30,162,31,181,31,162,31,70,31,226,31,24,31,72,31,20,31,30,31,30,30,123,31,205,31,47,31,47,30,61,31,25,31,25,30,78,31,108,31,221,31,221,30,6,31,6,30,227,31,125,31,32,31,116,31,141,31,141,31,228,31,74,31,96,31,90,31,140,31,99,31,4,31,231,31,84,31,84,30,158,31,103,31,204,31,204,30,44,31,175,31,198,31,47,31,238,31,68,31,149,31,149,30,115,31,25,31,174,31,174,30,86,31,86,30,151,31,88,31,218,31,7,31,149,31,39,31,41,31,19,31,28,31,223,31,223,30,223,29,168,31,25,31,16,31,75,31,109,31,100,31,24,31,76,31,149,31,39,31,94,31,66,31,173,31,173,30,76,31,140,31,198,31,121,31,24,31,24,30,213,31,220,31,26,31,56,31,218,31,195,31,205,31,205,30,195,31,129,31,142,31,134,31,172,31,172,30,142,31,142,30,111,31,144,31,101,31,226,31,155,31,155,30,155,29,141,31,26,31,233,31,146,31,178,31,211,31,221,31,22,31,146,31,146,30,218,31,155,31,44,31,192,31,25,31,25,30,192,31,23,31,196,31,211,31,179,31,7,31,92,31,223,31,254,31,254,30,254,29,160,31,12,31,12,30,134,31,247,31,32,31,164,31,33,31,232,31,189,31,74,31,74,30,137,31,76,31,76,30,53,31,15,31,26,31,130,31,235,31,6,31,119,31,119,30,119,29,215,31,79,31,12,31,12,30,178,31,153,31,29,31,28,31,112,31,177,31,76,31,131,31,131,30,179,31,179,30,238,31,142,31,205,31,156,31,103,31,247,31,247,30,23,31,4,31,220,31,237,31,70,31,233,31,59,31,232,31,91,31,151,31,76,31,76,30,119,31,228,31,228,30,201,31,130,31,175,31,19,31,121,31,120,31,141,31,143,31,228,31,139,31,16,31,147,31,132,31,175,31,215,31,215,30,3,31,6,31,67,31,232,31,80,31,87,31,225,31,7,31,57,31,194,31,3,31,3,30,48,31,104,31,145,31,237,31,237,30,89,31,128,31,84,31,205,31,239,31,210,31,7,31,66,31,12,31,210,31,210,30,144,31,36,31,30,31,30,30,30,29,243,31,85,31,179,31,239,31,197,31,177,31,74,31,113,31,229,31,186,31,76,31,71,31,230,31,198,31,107,31,101,31,238,31,201,31,24,31,251,31,177,31,232,31,5,31,205,31,171,31,136,31,250,31,250,30,155,31,168,31,105,31,29,31,71,31,40,31,40,30,73,31,217,31,171,31,171,30,80,31,183,31,216,31,214,31,172,31,224,31,123,31,123,30,123,29,56,31,148,31,148,30,62,31,62,30,17,31,73,31,117,31,101,31,178,31,206,31,126,31,196,31,196,30,235,31,183,31,183,30,183,29,236,31,231,31,181,31,247,31,97,31,97,30,14,31,24,31,214,31,133,31,50,31,141,31,141,30,154,31,198,31,213,31,82,31,82,30,82,29,192,31,119,31,188,31,188,30,39,31,39,30,34,31,64,31,64,30,64,29,70,31,85,31,85,30,97,31,153,31,183,31,183,30,209,31,16,31,16,30,253,31,253,30,182,31,182,30,31,31,31,30,122,31,19,31,205,31,249,31,249,30,170,31,170,30,186,31,221,31,137,31,137,30,149,31,213,31,108,31,108,30,157,31,182,31,221,31,180,31,5,31,6,31,86,31,13,31,13,30,13,29,112,31,127,31,206,31,231,31,33,31,175,31,126,31,129,31,99,31,141,31,148,31,37,31,66,31,121,31,117,31,112,31,169,31,224,31,107,31,233,31,233,30,79,31,79,30,44,31,19,31,19,30,235,31,253,31,180,31,180,30,25,31,136,31,162,31,90,31,86,31,86,30,147,31,245,31,3,31,28,31,24,31,220,31,220,30,101,31,79,31,73,31,60,31,71,31,117,31,117,30,165,31,253,31,253,30,149,31,161,31,61,31,61,30,56,31,141,31,141,30,24,31,139,31,233,31,233,30,252,31,252,30,77,31,77,30,49,31,57,31,228,31,113,31,170,31,81,31,18,31,145,31,154,31,154,30,38,31,209,31,57,31,157,31,157,30,126,31,97,31,21,31);

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
