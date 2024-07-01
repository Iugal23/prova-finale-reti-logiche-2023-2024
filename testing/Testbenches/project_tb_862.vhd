-- TB EXAMPLE PFRL 2023-2024

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use std.textio.all;

entity project_tb_862 is
end project_tb_862;

architecture project_tb_arch_862 of project_tb_862 is
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

constant SCENARIO_LENGTH : integer := 146;
    type scenario_type is array (0 to SCENARIO_LENGTH*2-1) of integer;

signal scenario_input : scenario_type := (177,0,1,0,11,0,212,0,0,0,0,0,0,0,155,0,132,0,0,0,255,0,124,0,245,0,49,0,0,0,223,0,160,0,106,0,119,0,244,0,75,0,107,0,252,0,221,0,0,0,40,0,194,0,206,0,85,0,9,0,241,0,244,0,211,0,0,0,205,0,204,0,88,0,45,0,250,0,0,0,0,0,58,0,127,0,174,0,152,0,70,0,10,0,93,0,58,0,57,0,252,0,0,0,166,0,143,0,48,0,252,0,75,0,223,0,206,0,0,0,206,0,200,0,194,0,7,0,74,0,5,0,0,0,0,0,141,0,0,0,0,0,119,0,101,0,133,0,105,0,41,0,110,0,141,0,0,0,255,0,6,0,199,0,221,0,162,0,225,0,140,0,0,0,184,0,140,0,234,0,0,0,191,0,13,0,72,0,197,0,0,0,126,0,48,0,209,0,51,0,75,0,214,0,254,0,114,0,72,0,207,0,60,0,178,0,0,0,205,0,8,0,73,0,111,0,211,0,0,0,148,0,185,0,1,0,8,0,15,0,248,0,151,0,0,0,215,0,154,0,128,0,0,0,82,0,84,0,129,0,111,0,107,0,71,0,0,0,219,0,196,0,209,0,21,0,19,0,0,0,233,0,120,0,119,0,0,0,0,0,0,0);
signal scenario_full  : scenario_type := (177,31,1,31,11,31,212,31,212,30,212,29,212,28,155,31,132,31,132,30,255,31,124,31,245,31,49,31,49,30,223,31,160,31,106,31,119,31,244,31,75,31,107,31,252,31,221,31,221,30,40,31,194,31,206,31,85,31,9,31,241,31,244,31,211,31,211,30,205,31,204,31,88,31,45,31,250,31,250,30,250,29,58,31,127,31,174,31,152,31,70,31,10,31,93,31,58,31,57,31,252,31,252,30,166,31,143,31,48,31,252,31,75,31,223,31,206,31,206,30,206,31,200,31,194,31,7,31,74,31,5,31,5,30,5,29,141,31,141,30,141,29,119,31,101,31,133,31,105,31,41,31,110,31,141,31,141,30,255,31,6,31,199,31,221,31,162,31,225,31,140,31,140,30,184,31,140,31,234,31,234,30,191,31,13,31,72,31,197,31,197,30,126,31,48,31,209,31,51,31,75,31,214,31,254,31,114,31,72,31,207,31,60,31,178,31,178,30,205,31,8,31,73,31,111,31,211,31,211,30,148,31,185,31,1,31,8,31,15,31,248,31,151,31,151,30,215,31,154,31,128,31,128,30,82,31,84,31,129,31,111,31,107,31,71,31,71,30,219,31,196,31,209,31,21,31,19,31,19,30,233,31,120,31,119,31,119,30,119,29,119,28);

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
