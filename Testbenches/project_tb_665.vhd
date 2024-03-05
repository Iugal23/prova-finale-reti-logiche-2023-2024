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

constant SCENARIO_LENGTH : integer := 269;
    type scenario_type is array (0 to SCENARIO_LENGTH*2-1) of integer;

signal scenario_input : scenario_type := (222,0,0,0,201,0,0,0,85,0,82,0,133,0,49,0,43,0,203,0,0,0,182,0,0,0,6,0,234,0,0,0,109,0,86,0,193,0,31,0,10,0,183,0,182,0,243,0,125,0,53,0,241,0,234,0,200,0,79,0,29,0,54,0,0,0,35,0,145,0,138,0,241,0,63,0,0,0,0,0,212,0,210,0,133,0,61,0,209,0,128,0,107,0,239,0,241,0,230,0,151,0,0,0,255,0,202,0,139,0,105,0,0,0,71,0,180,0,0,0,162,0,142,0,0,0,123,0,211,0,224,0,65,0,235,0,33,0,237,0,43,0,32,0,69,0,192,0,0,0,51,0,31,0,51,0,97,0,30,0,46,0,239,0,167,0,3,0,0,0,135,0,198,0,0,0,19,0,0,0,149,0,143,0,219,0,253,0,0,0,148,0,137,0,83,0,109,0,22,0,0,0,0,0,71,0,72,0,42,0,138,0,0,0,255,0,0,0,197,0,89,0,0,0,75,0,155,0,151,0,0,0,157,0,0,0,114,0,54,0,12,0,183,0,64,0,252,0,204,0,0,0,0,0,69,0,105,0,248,0,99,0,183,0,54,0,46,0,0,0,0,0,246,0,190,0,28,0,0,0,0,0,121,0,225,0,182,0,73,0,54,0,179,0,4,0,50,0,113,0,201,0,77,0,0,0,192,0,165,0,254,0,178,0,253,0,111,0,128,0,0,0,69,0,0,0,177,0,8,0,0,0,138,0,178,0,0,0,0,0,0,0,105,0,0,0,185,0,183,0,19,0,0,0,185,0,157,0,96,0,138,0,33,0,22,0,67,0,103,0,0,0,139,0,0,0,103,0,51,0,20,0,0,0,0,0,183,0,139,0,202,0,0,0,183,0,175,0,0,0,225,0,0,0,199,0,186,0,160,0,30,0,0,0,232,0,0,0,221,0,120,0,243,0,253,0,199,0,0,0,47,0,234,0,156,0,111,0,199,0,9,0,134,0,189,0,20,0,0,0,0,0,192,0,0,0,27,0,171,0,209,0,0,0,254,0,203,0,145,0,140,0,0,0,139,0,0,0,182,0,213,0,48,0,0,0,92,0,242,0,96,0,0,0,62,0,33,0,80,0,82,0,153,0,110,0,94,0,170,0,152,0,167,0,101,0,230,0,141,0,4,0,0,0,105,0,210,0,11,0,222,0,0,0,135,0,253,0);
signal scenario_full  : scenario_type := (222,31,222,30,201,31,201,30,85,31,82,31,133,31,49,31,43,31,203,31,203,30,182,31,182,30,6,31,234,31,234,30,109,31,86,31,193,31,31,31,10,31,183,31,182,31,243,31,125,31,53,31,241,31,234,31,200,31,79,31,29,31,54,31,54,30,35,31,145,31,138,31,241,31,63,31,63,30,63,29,212,31,210,31,133,31,61,31,209,31,128,31,107,31,239,31,241,31,230,31,151,31,151,30,255,31,202,31,139,31,105,31,105,30,71,31,180,31,180,30,162,31,142,31,142,30,123,31,211,31,224,31,65,31,235,31,33,31,237,31,43,31,32,31,69,31,192,31,192,30,51,31,31,31,51,31,97,31,30,31,46,31,239,31,167,31,3,31,3,30,135,31,198,31,198,30,19,31,19,30,149,31,143,31,219,31,253,31,253,30,148,31,137,31,83,31,109,31,22,31,22,30,22,29,71,31,72,31,42,31,138,31,138,30,255,31,255,30,197,31,89,31,89,30,75,31,155,31,151,31,151,30,157,31,157,30,114,31,54,31,12,31,183,31,64,31,252,31,204,31,204,30,204,29,69,31,105,31,248,31,99,31,183,31,54,31,46,31,46,30,46,29,246,31,190,31,28,31,28,30,28,29,121,31,225,31,182,31,73,31,54,31,179,31,4,31,50,31,113,31,201,31,77,31,77,30,192,31,165,31,254,31,178,31,253,31,111,31,128,31,128,30,69,31,69,30,177,31,8,31,8,30,138,31,178,31,178,30,178,29,178,28,105,31,105,30,185,31,183,31,19,31,19,30,185,31,157,31,96,31,138,31,33,31,22,31,67,31,103,31,103,30,139,31,139,30,103,31,51,31,20,31,20,30,20,29,183,31,139,31,202,31,202,30,183,31,175,31,175,30,225,31,225,30,199,31,186,31,160,31,30,31,30,30,232,31,232,30,221,31,120,31,243,31,253,31,199,31,199,30,47,31,234,31,156,31,111,31,199,31,9,31,134,31,189,31,20,31,20,30,20,29,192,31,192,30,27,31,171,31,209,31,209,30,254,31,203,31,145,31,140,31,140,30,139,31,139,30,182,31,213,31,48,31,48,30,92,31,242,31,96,31,96,30,62,31,33,31,80,31,82,31,153,31,110,31,94,31,170,31,152,31,167,31,101,31,230,31,141,31,4,31,4,30,105,31,210,31,11,31,222,31,222,30,135,31,253,31);

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
