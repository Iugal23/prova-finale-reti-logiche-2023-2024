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

constant SCENARIO_LENGTH : integer := 187;
    type scenario_type is array (0 to SCENARIO_LENGTH*2-1) of integer;

signal scenario_input : scenario_type := (241,0,50,0,121,0,7,0,189,0,17,0,156,0,184,0,73,0,118,0,148,0,152,0,0,0,190,0,114,0,253,0,115,0,31,0,254,0,236,0,151,0,40,0,0,0,194,0,0,0,117,0,133,0,0,0,2,0,0,0,0,0,158,0,0,0,202,0,229,0,0,0,14,0,21,0,103,0,138,0,104,0,29,0,43,0,181,0,240,0,0,0,196,0,63,0,93,0,51,0,199,0,55,0,36,0,236,0,185,0,118,0,248,0,163,0,27,0,0,0,44,0,0,0,44,0,224,0,0,0,165,0,230,0,28,0,119,0,175,0,209,0,110,0,238,0,54,0,5,0,152,0,123,0,126,0,0,0,67,0,202,0,100,0,110,0,0,0,0,0,83,0,255,0,241,0,58,0,115,0,0,0,225,0,45,0,175,0,0,0,20,0,10,0,164,0,143,0,38,0,82,0,189,0,247,0,209,0,65,0,30,0,95,0,155,0,247,0,122,0,0,0,154,0,95,0,0,0,188,0,234,0,161,0,142,0,127,0,146,0,12,0,0,0,0,0,203,0,23,0,63,0,191,0,42,0,191,0,105,0,115,0,144,0,192,0,250,0,239,0,64,0,0,0,0,0,0,0,220,0,22,0,21,0,147,0,0,0,145,0,0,0,185,0,175,0,102,0,0,0,131,0,0,0,160,0,171,0,37,0,0,0,136,0,109,0,157,0,44,0,141,0,240,0,208,0,17,0,13,0,0,0,34,0,21,0,0,0,66,0,7,0,112,0,0,0,0,0,75,0,0,0,158,0,22,0,0,0,0,0,232,0,223,0,12,0,80,0,32,0,171,0,178,0);
signal scenario_full  : scenario_type := (241,31,50,31,121,31,7,31,189,31,17,31,156,31,184,31,73,31,118,31,148,31,152,31,152,30,190,31,114,31,253,31,115,31,31,31,254,31,236,31,151,31,40,31,40,30,194,31,194,30,117,31,133,31,133,30,2,31,2,30,2,29,158,31,158,30,202,31,229,31,229,30,14,31,21,31,103,31,138,31,104,31,29,31,43,31,181,31,240,31,240,30,196,31,63,31,93,31,51,31,199,31,55,31,36,31,236,31,185,31,118,31,248,31,163,31,27,31,27,30,44,31,44,30,44,31,224,31,224,30,165,31,230,31,28,31,119,31,175,31,209,31,110,31,238,31,54,31,5,31,152,31,123,31,126,31,126,30,67,31,202,31,100,31,110,31,110,30,110,29,83,31,255,31,241,31,58,31,115,31,115,30,225,31,45,31,175,31,175,30,20,31,10,31,164,31,143,31,38,31,82,31,189,31,247,31,209,31,65,31,30,31,95,31,155,31,247,31,122,31,122,30,154,31,95,31,95,30,188,31,234,31,161,31,142,31,127,31,146,31,12,31,12,30,12,29,203,31,23,31,63,31,191,31,42,31,191,31,105,31,115,31,144,31,192,31,250,31,239,31,64,31,64,30,64,29,64,28,220,31,22,31,21,31,147,31,147,30,145,31,145,30,185,31,175,31,102,31,102,30,131,31,131,30,160,31,171,31,37,31,37,30,136,31,109,31,157,31,44,31,141,31,240,31,208,31,17,31,13,31,13,30,34,31,21,31,21,30,66,31,7,31,112,31,112,30,112,29,75,31,75,30,158,31,22,31,22,30,22,29,232,31,223,31,12,31,80,31,32,31,171,31,178,31);

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
