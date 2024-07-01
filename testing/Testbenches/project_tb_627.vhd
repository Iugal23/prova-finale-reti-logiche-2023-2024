-- TB EXAMPLE PFRL 2023-2024

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use std.textio.all;

entity project_tb_627 is
end project_tb_627;

architecture project_tb_arch_627 of project_tb_627 is
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

signal scenario_input : scenario_type := (0,0,188,0,0,0,109,0,70,0,20,0,123,0,0,0,52,0,43,0,245,0,179,0,172,0,59,0,141,0,50,0,46,0,202,0,46,0,57,0,200,0,46,0,8,0,170,0,0,0,0,0,212,0,223,0,0,0,189,0,64,0,0,0,125,0,49,0,128,0,181,0,0,0,128,0,60,0,72,0,204,0,156,0,120,0,146,0,35,0,81,0,31,0,193,0,0,0,0,0,167,0,177,0,0,0,30,0,42,0,0,0,130,0,0,0,171,0,210,0,68,0,97,0,0,0,0,0,228,0,208,0,0,0,0,0,131,0,46,0,189,0,48,0,147,0,181,0,0,0,45,0,0,0,0,0,196,0,0,0,143,0,121,0,129,0,175,0,0,0,171,0,235,0,156,0,36,0,0,0,208,0,0,0,78,0,0,0,245,0,169,0,0,0,0,0,251,0,251,0,123,0,81,0,47,0,92,0,158,0,41,0,174,0,40,0,153,0,254,0,213,0,122,0,10,0,0,0,242,0,162,0,120,0,221,0,0,0,0,0,163,0,8,0,0,0,0,0,0,0,121,0,105,0,0,0,154,0,170,0,14,0,54,0,74,0,0,0,130,0,186,0,152,0,0,0,100,0,212,0,0,0,58,0,198,0,89,0,0,0,0,0,63,0,58,0,126,0,125,0,245,0,202,0,75,0,61,0,0,0,87,0,0,0,89,0,181,0,167,0,136,0,241,0,0,0,132,0,236,0,0,0,187,0,0,0,189,0,141,0,16,0,165,0,56,0,59,0,25,0,0,0,52,0,143,0,46,0,54,0,46,0,163,0,255,0,0,0,211,0,40,0,200,0,34,0,125,0,0,0,115,0,183,0,0,0,114,0,26,0,0,0,136,0,208,0,211,0,0,0,99,0,103,0,77,0,120,0,0,0,47,0,100,0,248,0,112,0,150,0,128,0,147,0,0,0,236,0,225,0,231,0,0,0,223,0,0,0,53,0,189,0,62,0,234,0,98,0,93,0,215,0,0,0,76,0,0,0,85,0,0,0,162,0,149,0,239,0,141,0,218,0,40,0,0,0,10,0,151,0,196,0,0,0,85,0,138,0,84,0,85,0,157,0,0,0,197,0,0,0,0,0,66,0,251,0,131,0,127,0,0,0,111,0,108,0,0,0,0,0,38,0,0,0,226,0,0,0,2,0,62,0,0,0,147,0,76,0,0,0,4,0,126,0,29,0,207,0,16,0,80,0,118,0,45,0,147,0,158,0,33,0,229,0,0,0,0,0,0,0,198,0,105,0,252,0,208,0,137,0,229,0,0,0,96,0,224,0,244,0,124,0,103,0,47,0,123,0,111,0,157,0,34,0,122,0,0,0,0,0,186,0,124,0,110,0,177,0,0,0,0,0,190,0,0,0,229,0,172,0,0,0,3,0,105,0,18,0,62,0,91,0,63,0,211,0,0,0,47,0,236,0,39,0,232,0,114,0,73,0,44,0,69,0,10,0,15,0,0,0,215,0,53,0,0,0,0,0,221,0,82,0,169,0,114,0,0,0,186,0,143,0,134,0,198,0,123,0,155,0,99,0,136,0,113,0,7,0,207,0,123,0,87,0,0,0,0,0,0,0,15,0,55,0,203,0,176,0,230,0,0,0,0,0,0,0,214,0,146,0);
signal scenario_full  : scenario_type := (0,0,188,31,188,30,109,31,70,31,20,31,123,31,123,30,52,31,43,31,245,31,179,31,172,31,59,31,141,31,50,31,46,31,202,31,46,31,57,31,200,31,46,31,8,31,170,31,170,30,170,29,212,31,223,31,223,30,189,31,64,31,64,30,125,31,49,31,128,31,181,31,181,30,128,31,60,31,72,31,204,31,156,31,120,31,146,31,35,31,81,31,31,31,193,31,193,30,193,29,167,31,177,31,177,30,30,31,42,31,42,30,130,31,130,30,171,31,210,31,68,31,97,31,97,30,97,29,228,31,208,31,208,30,208,29,131,31,46,31,189,31,48,31,147,31,181,31,181,30,45,31,45,30,45,29,196,31,196,30,143,31,121,31,129,31,175,31,175,30,171,31,235,31,156,31,36,31,36,30,208,31,208,30,78,31,78,30,245,31,169,31,169,30,169,29,251,31,251,31,123,31,81,31,47,31,92,31,158,31,41,31,174,31,40,31,153,31,254,31,213,31,122,31,10,31,10,30,242,31,162,31,120,31,221,31,221,30,221,29,163,31,8,31,8,30,8,29,8,28,121,31,105,31,105,30,154,31,170,31,14,31,54,31,74,31,74,30,130,31,186,31,152,31,152,30,100,31,212,31,212,30,58,31,198,31,89,31,89,30,89,29,63,31,58,31,126,31,125,31,245,31,202,31,75,31,61,31,61,30,87,31,87,30,89,31,181,31,167,31,136,31,241,31,241,30,132,31,236,31,236,30,187,31,187,30,189,31,141,31,16,31,165,31,56,31,59,31,25,31,25,30,52,31,143,31,46,31,54,31,46,31,163,31,255,31,255,30,211,31,40,31,200,31,34,31,125,31,125,30,115,31,183,31,183,30,114,31,26,31,26,30,136,31,208,31,211,31,211,30,99,31,103,31,77,31,120,31,120,30,47,31,100,31,248,31,112,31,150,31,128,31,147,31,147,30,236,31,225,31,231,31,231,30,223,31,223,30,53,31,189,31,62,31,234,31,98,31,93,31,215,31,215,30,76,31,76,30,85,31,85,30,162,31,149,31,239,31,141,31,218,31,40,31,40,30,10,31,151,31,196,31,196,30,85,31,138,31,84,31,85,31,157,31,157,30,197,31,197,30,197,29,66,31,251,31,131,31,127,31,127,30,111,31,108,31,108,30,108,29,38,31,38,30,226,31,226,30,2,31,62,31,62,30,147,31,76,31,76,30,4,31,126,31,29,31,207,31,16,31,80,31,118,31,45,31,147,31,158,31,33,31,229,31,229,30,229,29,229,28,198,31,105,31,252,31,208,31,137,31,229,31,229,30,96,31,224,31,244,31,124,31,103,31,47,31,123,31,111,31,157,31,34,31,122,31,122,30,122,29,186,31,124,31,110,31,177,31,177,30,177,29,190,31,190,30,229,31,172,31,172,30,3,31,105,31,18,31,62,31,91,31,63,31,211,31,211,30,47,31,236,31,39,31,232,31,114,31,73,31,44,31,69,31,10,31,15,31,15,30,215,31,53,31,53,30,53,29,221,31,82,31,169,31,114,31,114,30,186,31,143,31,134,31,198,31,123,31,155,31,99,31,136,31,113,31,7,31,207,31,123,31,87,31,87,30,87,29,87,28,15,31,55,31,203,31,176,31,230,31,230,30,230,29,230,28,214,31,146,31);

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
