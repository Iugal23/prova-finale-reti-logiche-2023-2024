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

constant SCENARIO_LENGTH : integer := 407;
    type scenario_type is array (0 to SCENARIO_LENGTH*2-1) of integer;

signal scenario_input : scenario_type := (73,0,1,0,0,0,96,0,239,0,0,0,0,0,31,0,0,0,194,0,172,0,186,0,69,0,73,0,253,0,62,0,2,0,88,0,254,0,0,0,19,0,221,0,155,0,189,0,30,0,0,0,30,0,163,0,235,0,105,0,200,0,136,0,0,0,90,0,221,0,48,0,9,0,49,0,27,0,47,0,159,0,99,0,0,0,0,0,250,0,0,0,14,0,0,0,0,0,154,0,242,0,160,0,223,0,252,0,135,0,0,0,209,0,190,0,121,0,215,0,77,0,217,0,191,0,90,0,34,0,21,0,32,0,159,0,156,0,235,0,0,0,58,0,248,0,0,0,31,0,253,0,0,0,53,0,77,0,134,0,50,0,0,0,46,0,63,0,100,0,151,0,7,0,0,0,8,0,25,0,253,0,10,0,100,0,195,0,66,0,78,0,91,0,201,0,200,0,8,0,0,0,0,0,132,0,14,0,114,0,175,0,0,0,156,0,37,0,248,0,91,0,132,0,240,0,0,0,0,0,37,0,194,0,243,0,0,0,177,0,135,0,178,0,74,0,70,0,141,0,235,0,188,0,196,0,14,0,255,0,0,0,0,0,149,0,46,0,9,0,0,0,78,0,189,0,12,0,137,0,0,0,209,0,164,0,172,0,29,0,92,0,0,0,65,0,182,0,38,0,76,0,70,0,218,0,139,0,91,0,0,0,72,0,0,0,0,0,138,0,86,0,0,0,114,0,21,0,0,0,7,0,246,0,121,0,219,0,86,0,147,0,9,0,216,0,0,0,164,0,0,0,55,0,196,0,15,0,236,0,0,0,103,0,0,0,19,0,10,0,103,0,132,0,216,0,225,0,164,0,176,0,0,0,216,0,244,0,132,0,212,0,0,0,0,0,84,0,115,0,0,0,190,0,0,0,248,0,113,0,64,0,49,0,28,0,240,0,212,0,0,0,0,0,148,0,0,0,129,0,85,0,91,0,108,0,216,0,171,0,0,0,23,0,0,0,5,0,182,0,6,0,133,0,78,0,152,0,242,0,117,0,177,0,0,0,118,0,0,0,36,0,125,0,240,0,18,0,0,0,86,0,177,0,101,0,0,0,0,0,0,0,149,0,253,0,0,0,0,0,252,0,0,0,116,0,70,0,96,0,237,0,218,0,60,0,128,0,105,0,150,0,0,0,96,0,158,0,118,0,173,0,78,0,211,0,0,0,137,0,176,0,203,0,153,0,127,0,105,0,212,0,47,0,86,0,32,0,218,0,12,0,87,0,0,0,64,0,22,0,51,0,66,0,0,0,135,0,39,0,0,0,209,0,49,0,174,0,132,0,198,0,0,0,101,0,80,0,199,0,197,0,224,0,13,0,8,0,0,0,111,0,190,0,180,0,37,0,205,0,201,0,152,0,167,0,177,0,232,0,254,0,242,0,57,0,233,0,52,0,153,0,88,0,92,0,212,0,0,0,168,0,152,0,226,0,15,0,55,0,254,0,55,0,125,0,134,0,243,0,171,0,72,0,231,0,89,0,191,0,148,0,0,0,127,0,250,0,219,0,114,0,0,0,93,0,111,0,195,0,0,0,0,0,210,0,97,0,134,0,94,0,126,0,0,0,0,0,42,0,225,0,12,0,9,0,94,0,102,0,102,0,0,0,0,0,2,0,240,0,56,0,35,0,73,0,216,0,230,0,56,0,243,0,123,0,169,0,158,0,134,0,105,0,121,0,180,0,124,0,137,0,39,0,168,0,0,0,0,0,198,0,0,0,176,0,71,0,218,0,24,0,0,0,105,0,31,0,210,0,150,0,0,0,140,0,251,0,0,0,119,0,217,0);
signal scenario_full  : scenario_type := (73,31,1,31,1,30,96,31,239,31,239,30,239,29,31,31,31,30,194,31,172,31,186,31,69,31,73,31,253,31,62,31,2,31,88,31,254,31,254,30,19,31,221,31,155,31,189,31,30,31,30,30,30,31,163,31,235,31,105,31,200,31,136,31,136,30,90,31,221,31,48,31,9,31,49,31,27,31,47,31,159,31,99,31,99,30,99,29,250,31,250,30,14,31,14,30,14,29,154,31,242,31,160,31,223,31,252,31,135,31,135,30,209,31,190,31,121,31,215,31,77,31,217,31,191,31,90,31,34,31,21,31,32,31,159,31,156,31,235,31,235,30,58,31,248,31,248,30,31,31,253,31,253,30,53,31,77,31,134,31,50,31,50,30,46,31,63,31,100,31,151,31,7,31,7,30,8,31,25,31,253,31,10,31,100,31,195,31,66,31,78,31,91,31,201,31,200,31,8,31,8,30,8,29,132,31,14,31,114,31,175,31,175,30,156,31,37,31,248,31,91,31,132,31,240,31,240,30,240,29,37,31,194,31,243,31,243,30,177,31,135,31,178,31,74,31,70,31,141,31,235,31,188,31,196,31,14,31,255,31,255,30,255,29,149,31,46,31,9,31,9,30,78,31,189,31,12,31,137,31,137,30,209,31,164,31,172,31,29,31,92,31,92,30,65,31,182,31,38,31,76,31,70,31,218,31,139,31,91,31,91,30,72,31,72,30,72,29,138,31,86,31,86,30,114,31,21,31,21,30,7,31,246,31,121,31,219,31,86,31,147,31,9,31,216,31,216,30,164,31,164,30,55,31,196,31,15,31,236,31,236,30,103,31,103,30,19,31,10,31,103,31,132,31,216,31,225,31,164,31,176,31,176,30,216,31,244,31,132,31,212,31,212,30,212,29,84,31,115,31,115,30,190,31,190,30,248,31,113,31,64,31,49,31,28,31,240,31,212,31,212,30,212,29,148,31,148,30,129,31,85,31,91,31,108,31,216,31,171,31,171,30,23,31,23,30,5,31,182,31,6,31,133,31,78,31,152,31,242,31,117,31,177,31,177,30,118,31,118,30,36,31,125,31,240,31,18,31,18,30,86,31,177,31,101,31,101,30,101,29,101,28,149,31,253,31,253,30,253,29,252,31,252,30,116,31,70,31,96,31,237,31,218,31,60,31,128,31,105,31,150,31,150,30,96,31,158,31,118,31,173,31,78,31,211,31,211,30,137,31,176,31,203,31,153,31,127,31,105,31,212,31,47,31,86,31,32,31,218,31,12,31,87,31,87,30,64,31,22,31,51,31,66,31,66,30,135,31,39,31,39,30,209,31,49,31,174,31,132,31,198,31,198,30,101,31,80,31,199,31,197,31,224,31,13,31,8,31,8,30,111,31,190,31,180,31,37,31,205,31,201,31,152,31,167,31,177,31,232,31,254,31,242,31,57,31,233,31,52,31,153,31,88,31,92,31,212,31,212,30,168,31,152,31,226,31,15,31,55,31,254,31,55,31,125,31,134,31,243,31,171,31,72,31,231,31,89,31,191,31,148,31,148,30,127,31,250,31,219,31,114,31,114,30,93,31,111,31,195,31,195,30,195,29,210,31,97,31,134,31,94,31,126,31,126,30,126,29,42,31,225,31,12,31,9,31,94,31,102,31,102,31,102,30,102,29,2,31,240,31,56,31,35,31,73,31,216,31,230,31,56,31,243,31,123,31,169,31,158,31,134,31,105,31,121,31,180,31,124,31,137,31,39,31,168,31,168,30,168,29,198,31,198,30,176,31,71,31,218,31,24,31,24,30,105,31,31,31,210,31,150,31,150,30,140,31,251,31,251,30,119,31,217,31);

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
