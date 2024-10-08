-- TB EXAMPLE PFRL 2023-2024

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use std.textio.all;

entity project_tb_355 is
end project_tb_355;

architecture project_tb_arch_355 of project_tb_355 is
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

constant SCENARIO_LENGTH : integer := 398;
    type scenario_type is array (0 to SCENARIO_LENGTH*2-1) of integer;

signal scenario_input : scenario_type := (34,0,238,0,91,0,164,0,163,0,76,0,69,0,31,0,21,0,137,0,222,0,33,0,199,0,0,0,53,0,0,0,147,0,124,0,121,0,200,0,158,0,220,0,0,0,14,0,138,0,60,0,98,0,7,0,136,0,203,0,227,0,240,0,222,0,116,0,67,0,223,0,145,0,38,0,210,0,0,0,194,0,197,0,123,0,180,0,67,0,165,0,206,0,179,0,194,0,9,0,145,0,117,0,246,0,103,0,172,0,11,0,0,0,0,0,155,0,79,0,56,0,28,0,0,0,202,0,0,0,159,0,255,0,193,0,0,0,138,0,253,0,242,0,0,0,131,0,0,0,153,0,79,0,38,0,145,0,107,0,87,0,182,0,144,0,149,0,125,0,219,0,0,0,133,0,0,0,74,0,184,0,9,0,186,0,128,0,0,0,71,0,0,0,0,0,194,0,5,0,0,0,33,0,69,0,170,0,119,0,167,0,227,0,53,0,52,0,79,0,162,0,0,0,112,0,128,0,0,0,0,0,165,0,208,0,0,0,197,0,0,0,0,0,133,0,4,0,77,0,145,0,0,0,91,0,51,0,69,0,123,0,188,0,177,0,0,0,0,0,0,0,0,0,65,0,79,0,163,0,109,0,83,0,0,0,46,0,0,0,12,0,8,0,145,0,194,0,253,0,115,0,245,0,1,0,195,0,52,0,0,0,0,0,252,0,3,0,0,0,93,0,0,0,0,0,8,0,0,0,166,0,228,0,98,0,0,0,2,0,74,0,124,0,127,0,151,0,89,0,225,0,0,0,134,0,69,0,48,0,0,0,18,0,28,0,0,0,211,0,55,0,197,0,82,0,200,0,95,0,0,0,0,0,0,0,88,0,123,0,74,0,135,0,11,0,0,0,229,0,0,0,254,0,59,0,28,0,146,0,233,0,104,0,169,0,31,0,198,0,0,0,250,0,11,0,13,0,150,0,182,0,124,0,0,0,159,0,85,0,32,0,216,0,49,0,0,0,0,0,109,0,176,0,0,0,244,0,126,0,162,0,0,0,3,0,77,0,0,0,34,0,255,0,107,0,58,0,42,0,230,0,130,0,0,0,0,0,137,0,166,0,53,0,142,0,200,0,121,0,211,0,239,0,157,0,82,0,91,0,58,0,133,0,72,0,14,0,0,0,229,0,184,0,104,0,0,0,164,0,252,0,237,0,165,0,35,0,126,0,100,0,0,0,8,0,174,0,0,0,2,0,188,0,0,0,136,0,76,0,165,0,0,0,216,0,0,0,0,0,0,0,214,0,159,0,0,0,0,0,82,0,0,0,87,0,100,0,181,0,73,0,243,0,134,0,0,0,126,0,157,0,118,0,248,0,0,0,166,0,196,0,16,0,109,0,0,0,127,0,30,0,212,0,113,0,101,0,179,0,175,0,0,0,138,0,138,0,99,0,252,0,38,0,15,0,138,0,56,0,217,0,114,0,0,0,52,0,169,0,1,0,0,0,85,0,144,0,156,0,104,0,0,0,19,0,8,0,62,0,248,0,195,0,181,0,104,0,117,0,0,0,234,0,166,0,168,0,64,0,125,0,0,0,0,0,0,0,0,0,0,0,103,0,113,0,0,0,0,0,80,0,169,0,104,0,234,0,109,0,168,0,85,0,221,0,228,0,71,0,125,0,41,0,243,0,248,0,155,0,0,0,241,0,253,0,111,0,193,0,52,0,55,0,9,0,33,0,0,0,145,0,179,0,237,0,56,0,174,0,64,0,167,0,14,0,0,0,60,0,74,0,213,0,152,0);
signal scenario_full  : scenario_type := (34,31,238,31,91,31,164,31,163,31,76,31,69,31,31,31,21,31,137,31,222,31,33,31,199,31,199,30,53,31,53,30,147,31,124,31,121,31,200,31,158,31,220,31,220,30,14,31,138,31,60,31,98,31,7,31,136,31,203,31,227,31,240,31,222,31,116,31,67,31,223,31,145,31,38,31,210,31,210,30,194,31,197,31,123,31,180,31,67,31,165,31,206,31,179,31,194,31,9,31,145,31,117,31,246,31,103,31,172,31,11,31,11,30,11,29,155,31,79,31,56,31,28,31,28,30,202,31,202,30,159,31,255,31,193,31,193,30,138,31,253,31,242,31,242,30,131,31,131,30,153,31,79,31,38,31,145,31,107,31,87,31,182,31,144,31,149,31,125,31,219,31,219,30,133,31,133,30,74,31,184,31,9,31,186,31,128,31,128,30,71,31,71,30,71,29,194,31,5,31,5,30,33,31,69,31,170,31,119,31,167,31,227,31,53,31,52,31,79,31,162,31,162,30,112,31,128,31,128,30,128,29,165,31,208,31,208,30,197,31,197,30,197,29,133,31,4,31,77,31,145,31,145,30,91,31,51,31,69,31,123,31,188,31,177,31,177,30,177,29,177,28,177,27,65,31,79,31,163,31,109,31,83,31,83,30,46,31,46,30,12,31,8,31,145,31,194,31,253,31,115,31,245,31,1,31,195,31,52,31,52,30,52,29,252,31,3,31,3,30,93,31,93,30,93,29,8,31,8,30,166,31,228,31,98,31,98,30,2,31,74,31,124,31,127,31,151,31,89,31,225,31,225,30,134,31,69,31,48,31,48,30,18,31,28,31,28,30,211,31,55,31,197,31,82,31,200,31,95,31,95,30,95,29,95,28,88,31,123,31,74,31,135,31,11,31,11,30,229,31,229,30,254,31,59,31,28,31,146,31,233,31,104,31,169,31,31,31,198,31,198,30,250,31,11,31,13,31,150,31,182,31,124,31,124,30,159,31,85,31,32,31,216,31,49,31,49,30,49,29,109,31,176,31,176,30,244,31,126,31,162,31,162,30,3,31,77,31,77,30,34,31,255,31,107,31,58,31,42,31,230,31,130,31,130,30,130,29,137,31,166,31,53,31,142,31,200,31,121,31,211,31,239,31,157,31,82,31,91,31,58,31,133,31,72,31,14,31,14,30,229,31,184,31,104,31,104,30,164,31,252,31,237,31,165,31,35,31,126,31,100,31,100,30,8,31,174,31,174,30,2,31,188,31,188,30,136,31,76,31,165,31,165,30,216,31,216,30,216,29,216,28,214,31,159,31,159,30,159,29,82,31,82,30,87,31,100,31,181,31,73,31,243,31,134,31,134,30,126,31,157,31,118,31,248,31,248,30,166,31,196,31,16,31,109,31,109,30,127,31,30,31,212,31,113,31,101,31,179,31,175,31,175,30,138,31,138,31,99,31,252,31,38,31,15,31,138,31,56,31,217,31,114,31,114,30,52,31,169,31,1,31,1,30,85,31,144,31,156,31,104,31,104,30,19,31,8,31,62,31,248,31,195,31,181,31,104,31,117,31,117,30,234,31,166,31,168,31,64,31,125,31,125,30,125,29,125,28,125,27,125,26,103,31,113,31,113,30,113,29,80,31,169,31,104,31,234,31,109,31,168,31,85,31,221,31,228,31,71,31,125,31,41,31,243,31,248,31,155,31,155,30,241,31,253,31,111,31,193,31,52,31,55,31,9,31,33,31,33,30,145,31,179,31,237,31,56,31,174,31,64,31,167,31,14,31,14,30,60,31,74,31,213,31,152,31);

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
