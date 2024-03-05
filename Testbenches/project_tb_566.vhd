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

constant SCENARIO_LENGTH : integer := 223;
    type scenario_type is array (0 to SCENARIO_LENGTH*2-1) of integer;

signal scenario_input : scenario_type := (167,0,42,0,87,0,170,0,129,0,65,0,0,0,65,0,242,0,179,0,33,0,239,0,45,0,103,0,53,0,0,0,0,0,61,0,70,0,253,0,24,0,97,0,69,0,100,0,100,0,140,0,99,0,162,0,14,0,0,0,219,0,223,0,122,0,162,0,242,0,4,0,214,0,123,0,99,0,175,0,124,0,152,0,222,0,87,0,0,0,44,0,27,0,171,0,0,0,63,0,84,0,0,0,230,0,227,0,9,0,204,0,62,0,38,0,19,0,5,0,0,0,169,0,38,0,228,0,154,0,223,0,77,0,16,0,0,0,132,0,0,0,5,0,20,0,249,0,83,0,87,0,143,0,44,0,18,0,164,0,44,0,47,0,252,0,244,0,44,0,123,0,124,0,101,0,28,0,190,0,153,0,0,0,59,0,202,0,101,0,9,0,71,0,0,0,254,0,116,0,80,0,0,0,56,0,145,0,250,0,27,0,199,0,144,0,36,0,236,0,139,0,104,0,139,0,169,0,179,0,229,0,224,0,178,0,155,0,40,0,0,0,0,0,164,0,90,0,220,0,0,0,2,0,216,0,151,0,162,0,0,0,0,0,109,0,185,0,253,0,211,0,0,0,109,0,16,0,168,0,0,0,145,0,150,0,0,0,180,0,66,0,139,0,134,0,134,0,0,0,0,0,156,0,142,0,92,0,178,0,0,0,0,0,99,0,62,0,221,0,92,0,0,0,234,0,0,0,106,0,237,0,140,0,179,0,107,0,72,0,0,0,112,0,6,0,0,0,129,0,158,0,174,0,110,0,0,0,65,0,0,0,32,0,0,0,58,0,59,0,183,0,69,0,0,0,99,0,53,0,68,0,60,0,0,0,141,0,100,0,148,0,70,0,169,0,81,0,26,0,183,0,6,0,161,0,111,0,0,0,84,0,96,0,98,0,0,0,48,0,27,0,71,0,207,0,142,0,141,0,0,0,110,0,9,0,229,0,19,0,184,0,88,0,0,0);
signal scenario_full  : scenario_type := (167,31,42,31,87,31,170,31,129,31,65,31,65,30,65,31,242,31,179,31,33,31,239,31,45,31,103,31,53,31,53,30,53,29,61,31,70,31,253,31,24,31,97,31,69,31,100,31,100,31,140,31,99,31,162,31,14,31,14,30,219,31,223,31,122,31,162,31,242,31,4,31,214,31,123,31,99,31,175,31,124,31,152,31,222,31,87,31,87,30,44,31,27,31,171,31,171,30,63,31,84,31,84,30,230,31,227,31,9,31,204,31,62,31,38,31,19,31,5,31,5,30,169,31,38,31,228,31,154,31,223,31,77,31,16,31,16,30,132,31,132,30,5,31,20,31,249,31,83,31,87,31,143,31,44,31,18,31,164,31,44,31,47,31,252,31,244,31,44,31,123,31,124,31,101,31,28,31,190,31,153,31,153,30,59,31,202,31,101,31,9,31,71,31,71,30,254,31,116,31,80,31,80,30,56,31,145,31,250,31,27,31,199,31,144,31,36,31,236,31,139,31,104,31,139,31,169,31,179,31,229,31,224,31,178,31,155,31,40,31,40,30,40,29,164,31,90,31,220,31,220,30,2,31,216,31,151,31,162,31,162,30,162,29,109,31,185,31,253,31,211,31,211,30,109,31,16,31,168,31,168,30,145,31,150,31,150,30,180,31,66,31,139,31,134,31,134,31,134,30,134,29,156,31,142,31,92,31,178,31,178,30,178,29,99,31,62,31,221,31,92,31,92,30,234,31,234,30,106,31,237,31,140,31,179,31,107,31,72,31,72,30,112,31,6,31,6,30,129,31,158,31,174,31,110,31,110,30,65,31,65,30,32,31,32,30,58,31,59,31,183,31,69,31,69,30,99,31,53,31,68,31,60,31,60,30,141,31,100,31,148,31,70,31,169,31,81,31,26,31,183,31,6,31,161,31,111,31,111,30,84,31,96,31,98,31,98,30,48,31,27,31,71,31,207,31,142,31,141,31,141,30,110,31,9,31,229,31,19,31,184,31,88,31,88,30);

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
