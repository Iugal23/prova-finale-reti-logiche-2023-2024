-- TB EXAMPLE PFRL 2023-2024

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use std.textio.all;

entity project_tb_329 is
end project_tb_329;

architecture project_tb_arch_329 of project_tb_329 is
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

signal scenario_input : scenario_type := (240,0,145,0,84,0,203,0,203,0,0,0,0,0,138,0,48,0,224,0,17,0,122,0,87,0,251,0,155,0,219,0,50,0,16,0,0,0,0,0,251,0,40,0,0,0,0,0,51,0,151,0,119,0,24,0,29,0,173,0,251,0,51,0,228,0,97,0,95,0,14,0,250,0,71,0,145,0,0,0,169,0,0,0,28,0,237,0,46,0,229,0,0,0,0,0,213,0,217,0,156,0,213,0,64,0,40,0,248,0,50,0,189,0,107,0,67,0,186,0,101,0,0,0,148,0,83,0,23,0,65,0,0,0,0,0,138,0,139,0,162,0,55,0,0,0,0,0,192,0,113,0,60,0,207,0,233,0,0,0,100,0,66,0,56,0,223,0,251,0,139,0,133,0,5,0,179,0,155,0,0,0,130,0,11,0,85,0,26,0,0,0,70,0,146,0,0,0,0,0,138,0,184,0,241,0,173,0,58,0,241,0,119,0,234,0,195,0,186,0,0,0,128,0,208,0,66,0,223,0,0,0,0,0,27,0,94,0,98,0,0,0,25,0,0,0,5,0,38,0,208,0,225,0,111,0,87,0,0,0,217,0,0,0,47,0,225,0,0,0,0,0,109,0,187,0,24,0,237,0,0,0,13,0,80,0,0,0,208,0,53,0,75,0,130,0,120,0,0,0,6,0,0,0,114,0,14,0,33,0,232,0,198,0,184,0,0,0,44,0,0,0,36,0,0,0,176,0,227,0,151,0,31,0,88,0,63,0,124,0,96,0,0,0,26,0,28,0,29,0,145,0,67,0,159,0,88,0,255,0,205,0,213,0,38,0,0,0,136,0,132,0,51,0,56,0,132,0,0,0,236,0,16,0,0,0,107,0,209,0,88,0,0,0,64,0,89,0,0,0,112,0,155,0,137,0,242,0,197,0,0,0,98,0,0,0,89,0,0,0,0,0,0,0,213,0,62,0,19,0,62,0,128,0,52,0,0,0,191,0,218,0,59,0,113,0,189,0,61,0);
signal scenario_full  : scenario_type := (240,31,145,31,84,31,203,31,203,31,203,30,203,29,138,31,48,31,224,31,17,31,122,31,87,31,251,31,155,31,219,31,50,31,16,31,16,30,16,29,251,31,40,31,40,30,40,29,51,31,151,31,119,31,24,31,29,31,173,31,251,31,51,31,228,31,97,31,95,31,14,31,250,31,71,31,145,31,145,30,169,31,169,30,28,31,237,31,46,31,229,31,229,30,229,29,213,31,217,31,156,31,213,31,64,31,40,31,248,31,50,31,189,31,107,31,67,31,186,31,101,31,101,30,148,31,83,31,23,31,65,31,65,30,65,29,138,31,139,31,162,31,55,31,55,30,55,29,192,31,113,31,60,31,207,31,233,31,233,30,100,31,66,31,56,31,223,31,251,31,139,31,133,31,5,31,179,31,155,31,155,30,130,31,11,31,85,31,26,31,26,30,70,31,146,31,146,30,146,29,138,31,184,31,241,31,173,31,58,31,241,31,119,31,234,31,195,31,186,31,186,30,128,31,208,31,66,31,223,31,223,30,223,29,27,31,94,31,98,31,98,30,25,31,25,30,5,31,38,31,208,31,225,31,111,31,87,31,87,30,217,31,217,30,47,31,225,31,225,30,225,29,109,31,187,31,24,31,237,31,237,30,13,31,80,31,80,30,208,31,53,31,75,31,130,31,120,31,120,30,6,31,6,30,114,31,14,31,33,31,232,31,198,31,184,31,184,30,44,31,44,30,36,31,36,30,176,31,227,31,151,31,31,31,88,31,63,31,124,31,96,31,96,30,26,31,28,31,29,31,145,31,67,31,159,31,88,31,255,31,205,31,213,31,38,31,38,30,136,31,132,31,51,31,56,31,132,31,132,30,236,31,16,31,16,30,107,31,209,31,88,31,88,30,64,31,89,31,89,30,112,31,155,31,137,31,242,31,197,31,197,30,98,31,98,30,89,31,89,30,89,29,89,28,213,31,62,31,19,31,62,31,128,31,52,31,52,30,191,31,218,31,59,31,113,31,189,31,61,31);

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
